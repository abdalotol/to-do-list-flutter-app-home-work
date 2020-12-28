class Mission{
  int _Id;
  String _Address;
  int _Input;

  Mission(
    this._Address,

    this._Input,

  );

  Mission.withId(this._Id, this._Address, this._Input);

  int get_Id => _Id;

  String get_Address => _Address;

  int get_Input => _Input;

  set Address(String newAddress) {
    if (newAddress.length <= 255) {
      this._Address = newAddress;
    }
  }

  set Input(int newInput) {
    this._Input = newInput;
  }



  Map<String, dynamic> toMap() {
  var map = Map<String, dynamic>();
    if (Id != null) {
      map['Id'] = _Id;
    }
    map['Address'] = _Address;
    map['Input'] = _Input;

    return map;
  }

   Mission.fromMapObject(Map<String, dynamic> map) {
    this._Id = map['Id'];
    this._Address = map['Address'];
    this._Input = map['Input'];
  }
}
