class ParentTreeData {
  String title;
  List<ChildTreeData> children;
  int _optionsCount = 0;
  int _selected = 0;
  bool? state;

  ParentTreeData({
    required this.title,
    required this.children,
  }) {
    for(ChildTreeData child in children) {
      _optionsCount += child.optionsCount;
      _selected += child.selected;
    }
    _updateGlobalState();
  }

  void changeState() {
    switch (state) {
      case true:
        _setChildren(false);
        state = false;
        _selected = 0;
      default:
        _setChildren(true);
        state = true;
        _selected = _optionsCount;

    }
  }

  void _updateGlobalState() {
    if (_selected == 0) {
      state = false;
    } else if (_selected == _optionsCount) {
      state = true;
    } else {
      state = null;
    }
  }

  void updateSelectedCount(int selected) {
    _selected += selected;
    _updateGlobalState();
  }

  void _setChildren(bool selected) {
    for (ChildTreeData child in children) {
      child.setAllValues(selected);
    }
  }


}
class ChildTreeData {
  String title;
  List<ValueTreeData> children;
  int optionsCount = 0;
  int selected = 0;
  bool? state;
  
  ChildTreeData({
    required this.title,
    required this.children,
  }) {
    optionsCount = children.length;
    for(ValueTreeData pair in children) {
      if (pair.selected) {
        selected++;
      }
    }
    _updateGlobalState();    
  }


  /// Retrieves the number of selected options modified, 
  /// positive if are selected 
  /// and negative if are unselected
  int changeState() {
    int changed;
    switch (state) {
      case true:
        setAllValues(false);
        state = false;
        changed = -selected;
        selected = 0;
      default:
        setAllValues(true);
        state = true;
        changed = optionsCount - selected;
        selected = optionsCount;
    }
    return changed;
  }

  void _updateGlobalState() {
    if (selected == 0) {
      state = false;
    } else if (selected == optionsCount) {
      state = true;
    } else {
      state = null;
    }
  }

  void updateSelected(int selectedCount) {
    selected += selectedCount;
    _updateGlobalState();
  }

  void setAllValues(bool selected) {
    state = selected;
    for (ValueTreeData pair in children) {
      pair.selected = selected;
    }
  }

}
class ValueTreeData {
  String data;
  bool selected;

  ValueTreeData ({
    required this.data,
    this.selected = false,
  });

  int switchSelected() {
    selected = !selected;
    return selected? 1 : -1;
  } 
}
