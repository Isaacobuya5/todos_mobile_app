// database model for our application
class Todo {
  
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  // constructor for creating a new todo
  Todo(this._title,this._priority,this._date,[this._description]);

  // constructing for updating a new todo with a given id
  Todo.withId(this._id, this._title,this._priority,this._date,[this._description]);

  // getters
  int get id => _id;
  String get title => _title;
  String get date => _date;
  String get description => _description;
  int get priority => _priority;

  // setter methods
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

    set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

    set priority(int newPriority) {
    if (newPriority >= 0 && newPriority <= 3) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

// store each todo in a map
//map - is a collection of key/value pairs from which we retrieve a value based on a key
  Map<String, dynamic> toMap() {
  var map = Map<String, dynamic>();
  map["title"] = _title;
  map["description"] = _description;
  map["priority"] = _priority;
  map["date"] = _date;
  if (_id != null) {
    map["id"] = _id;
  }
  return map;
  }

  // another constructor to transform the collection to an object
  Todo.fromObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._priority = o["priority"];
    this._date = o["date"];
  }
}

