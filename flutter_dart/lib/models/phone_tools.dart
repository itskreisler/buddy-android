class PhoneTool {
  final String name;
  final String description;

  const PhoneTool({required this.name, required this.description});

  static const List<PhoneTool> tools = [
    PhoneTool(name: 'read_screen', description: 'Reads interactive elements on the screen'),
    PhoneTool(name: 'tap', description: 'Taps at given x,y coordinates or text'),
    PhoneTool(name: 'type_text', description: 'Types text into focused input'),
    PhoneTool(name: 'scroll', description: 'Scrolls screen up/down/left/right'),
    PhoneTool(name: 'open_app', description: 'Opens application by package or name'),
    PhoneTool(name: 'confirm', description: 'Asks user for approval before performing action'),
    PhoneTool(name: 'ask', description: 'Presents a multiple choice question to user'),
  ];
}
