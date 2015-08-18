//config.js
.import QtQuick.LocalStorage 2.0 as LS
// First, let's create a short helper function to get the database connection
function getDatabase() {
    return LS.LocalStorage.openDatabaseSync("Noto", "1.0", "StorageDatabase", 100000);
}

// We want a unique id for notes

// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    // Create the settings table if it doesn't already exist
                    // If the table exists, this is skipped
                    tx.executeSql('CREATE TABLE IF NOT EXISTS notes(uid LONGVARCHAR UNIQUE, title TEXT,txt TEXT,color TEXT, datetime TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS todolist(title TEXT, lid LONGVARCHAR UNIQUE, color TEXT,clearCount INTEGER, todosCount INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS todos(lid LONGVARCHAR, todo TEXT,status INTEGER,uid LONGVARCHAR UNIQUE)');
                    tx.executeSql('CREATE UNIQUE INDEX IF NOT EXISTS idx ON todolist(title,lid);');
                });
}

// This function is used to write notes into the database
function setNote(uid,title,txt,color,datetime) {
    // title: name representing the title of the note
    // txt: text of the note
    // color: color used to represent this note
    // datetime: Time + Date when created
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO notes VALUES (?,?,?,?,?);', [uid,title,txt,color,datetime]);
        if (rs.rowsAffected > 0) {
            res = "OK";
            //console.log ("Saved to database");
        } else {
            res = "Error";
            //console.log ("Error saving to database");
        }
    }
    );
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

// This function is used to write todoList into the database
function setTodoList(title,lid,color,clearCount,todosCount) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO todolist VALUES (?,?,?,?,?);', [title,lid,color,clearCount,todosCount]);
        //console.log(rs.rowsAffected)
        if (rs.rowsAffected > 0) {
            res = "OK";
            //console.log ("Saved to database");
        } else {
            res = "Error";
            //console.log ("Error saving to database");
        }
    }
    );
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}
// TODO: Add setTodo function for writing the actual todos into todos database
// This function is used to write or replace todos into the database
function setTodo(title,lid,status,uid) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO todos VALUES (?,?,?,?,?);', [title,lid,status,uid]);
        //console.log(rs.rowsAffected)
        if (rs.rowsAffected > 0) {
            res = "OK";
            //console.log ("Saved to database");
        } else {
            res = "Error";
            //console.log ("Error saving to database");
        }
    }
    );
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

// This function is used to retrieve a notes from the database
function getNotes() {
    var db = getDatabase();
    var respath="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT DISTINCT title,uid,color FROM notes;');
        for (var i = 0; i < rs.rows.length; i++) {
            mainWindow.addNote(rs.rows.item(i).title,rs.rows.item(i).uid,rs.rows.item(i).color)
            //console.debug("get Notes:" + rs.rows.item(i).title + " with id:" + rs.rows.item(i).uid,rs.rows.item(i).color)
        }
    })
}

// This function is used to retrieve todos from the database
function getTodoList() {
    var db = getDatabase();
    var respath="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT DISTINCT title,lid,color,clearCount,todosCount FROM todolist;');
        for (var i = 0; i < rs.rows.length; i++) {
            // Syntax help: addTodoList(todoListTitle,lId,todoListColor,todoListClearCount,todoListTodosCount)
            mainWindow.addTodoList(rs.rows.item(i).title,rs.rows.item(i).lid,rs.rows.item(i).color,rs.rows.item(i).clearCount,rs.rows.item(i).todosCount)
        }
    })
}

// This function is used to retrieve a text from a note in the database
function getText(title,uid) {
    var db = getDatabase();
    var notesText="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT txt FROM notes WHERE title=? AND uid=?;', [title,uid]);
        //console.debug(title + " " + uid)
        if (rs.rows.length > 0) {
            notesText = rs.rows.item(0).txt
        } else {
            notesText = "Unknown"
        }
    })
    // The function returns “Unknown” if the setting was not found in the database
    // For more advanced projects, this should probably be handled through error codes
    return notesText
} 

// I seem not clever enough to only make this in one function so here is another one
function getTodos(lid) {
    var db = getDatabase();
    var todoText="";
    var todoStatus="";
    var todoUid="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT todo,status,uid FROM todos WHERE lid=?;', [lid]);
        for (var i = 0; i < rs.rows.length; i++) {
            if (rs.rows.length > 0) {
                var row = rs.rows.item(i)
                //console.debug(row['todo'])
                //console.debug(row['status'])
                //console.debug(row['uid'])
                // Syntax help : addTodo(todoTitle,lId,todoStatus,todoUid)
                mainWindow.addTodo(row['todo'],lid,row['status'],row['uid'])
            } else {
                todoText = "Unknown"
                todoStatus = 0
                todoUid = 0
            }
        }
    })
    // The function returns “Unknown” if the setting was not found in the database
    // For more advanced projects, this should probably be handled through error codes
    return [todoText,todoStatus,todoUid];
}

// This function is used to remove a note or todo from the database
function remove(title,type,uid) {
    var db = getDatabase();
    var respath="";
    if (type === "note") {
        //console.debug("Removing Note: " + uid)
        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM notes WHERE title=? AND uid=?;' , [title,uid]);
        })
    }
    else if  (type === "todo") {
        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM todos WHERE title=?;' , [title]);
        })
    }
}

// This function is used to remove todo entry from a todo in the database
function removeTodoEntry(title,todo,uid) {
    var db = getDatabase();
    var respath="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM todos WHERE title=? AND todo=? AND uid=?;' , [title,todo,uid]);
    })
}

