
TypeWriter typeWriter;
void setup() {
  size(400, 300, P3D);
  typeWriter = new Typer();
  frameRate(20);
  
  setupTypeWriter();
}

void draw() {
  background(255);
  
  typeWriter = typeWriter.update();
}

ArrayList<String> lines = new ArrayList<String>();
abstract class TypeWriter {
  
  final int MAX_LINES = 15;
  final int FONT_SIZE = 10;
  final int WAIT_TIME = 12;
  final int START_X = 10;
  final int START_Y = 10 + FONT_SIZE;
  final color FONT_COLOR = 0xFF00CC10;
  
  int endPosition;
  
  TypeWriter() {
    endPosition = 0;
  }
  
  public void addLine(String newLine) {
    addLines(newLine.split("¥n"));
  }
  
  public void addLines(String[] newLines) {
    for(String line : newLines) lines.add(line);
  }
  
  protected int getAllStringLength() {
    int len = 0;
    for(String line : lines) len += line.length();
    return len;
  }
  
  // テンプレートメソッド的な
  TypeWriter update() {
    pushMatrix();
    camera();
    textSize(FONT_SIZE);
    textFont(createFont("monospace", FONT_SIZE));
    fill(FONT_COLOR);
    
    
    // サブクラスの具象メソッドに委譲
    TypeWriter ret = display();
    
    popMatrix();
    return ret;
  }
  
  // 抽象メソッド
  protected abstract TypeWriter display();
}

// 文字を打ち出す人
class Typer extends TypeWriter {
  int _endPosition;

  Typer() { this(0); }
  
  Typer(int endPosition) {
    _endPosition = endPosition;
  }
  
  protected TypeWriter display() {
    if(getAllStringLength() == 0) {
      _endPosition = 0;
      return this;
    }
    
    int textLength = ++_endPosition;
    for(int i = 0; i < min(MAX_LINES, lines.size()); ++i) {
      String line = (textLength < lines.get(i).length()) ? 
        lines.get(i).substring(0, textLength) : lines.get(i);
      
      text(line, START_X, START_Y + i * FONT_SIZE);
      textLength -= line.length();
      if(!(0 < textLength)) {
        return this;
      }
    }
    
    return new Waiter(_endPosition -1);
  }
}

// 待つ人
class Waiter extends TypeWriter {
  int _counter;
  int _endPosition;
  Waiter(int endPosition) {
    _counter = 0;
    _endPosition = endPosition;
  }
  
  protected TypeWriter display() {
    ++_counter;
    for(int i = 0; i < min(MAX_LINES, lines.size()); ++i) {
      String line = lines.get(i);
      text(line, START_X, START_Y + i * FONT_SIZE);
    }
    return WAIT_TIME < _counter || _endPosition < getAllStringLength() ?
      new Elevator(_endPosition) : this;
  }
}

// 位置を送る人
class Elevator extends TypeWriter {
  int _endPosition;
  int _counter;
  Elevator(int endPosition) {
    _endPosition = endPosition;
    _counter = 0;
  }
  
  protected TypeWriter display() {
    int textLength = ++_endPosition - lines.get(0).length();
    
    // 1行目がなめらかに消えるように、
    // 縦方向に縮小するアニメーションを行う。
    pushMatrix();
    translate(0,  FONT_SIZE * 0.5);
    scale(1.0, 1.0 - ++_counter / (float)FONT_SIZE, 1.0);
    translate(0, - FONT_SIZE * 0.5);
    text(lines.get(0), START_X, START_Y);    
    popMatrix();
    
    // 2行目以降の表示
    for(int i = 1; i < min(MAX_LINES, lines.size()); ++i) {
      String line = lines.get(i);
      textLength -= line.length();
      text(line, START_X, START_Y + i * FONT_SIZE - _counter);
    }
    
    if (0 < textLength && MAX_LINES < lines.size()) {
      String line = textLength < lines.get(MAX_LINES).length() ?
        lines.get(MAX_LINES).substring(0, textLength) : lines.get(MAX_LINES);      
      text(line, START_X, START_Y + (MAX_LINES) * FONT_SIZE - _counter);
    } else  --_endPosition;

    if(++_counter < FONT_SIZE) return this;
    
    _endPosition -= lines.get(0).length();    
    if(MAX_LINES < lines.size() && 
       lines.get(MAX_LINES).length() < textLength)
         _endPosition -= (textLength - lines.get(MAX_LINES).length());
    
    lines.remove(0);
    return new Typer(_endPosition);
  }
}


void setupTypeWriter() {
  typeWriter.addLine("/* --------------------------------------------------");
  typeWriter.addLine("");
  typeWriter.addLine("+-----             |      |");
  typeWriter.addLine("|     |         -  |      |");
  typeWriter.addLine("+-----   |   |     |   ---+");
  typeWriter.addLine("|     |  |   |  |  |  |   |");
  typeWriter.addLine("+-----    ---+  |  |   ---+");
  typeWriter.addLine("");
  typeWriter.addLine("         -    |    |");
  typeWriter.addLine("|  |  |     --+--  |---");
  typeWriter.addLine("|  |  |  |    |    |   |");
  typeWriter.addLine(" -- --   |    \\--  |   |");
  typeWriter.addLine("");
  typeWriter.addLine("+----- ");
  typeWriter.addLine("|     |                                     -");
  typeWriter.addLine("+-----   ---  ---   --- +---+  ----  ----   +---   ---+");
  typeWriter.addLine("|       |    |   | |    +---+ +---+ +---+ | |   | |   |");
  typeWriter.addLine("|       |     ---   --- +---- ----  ----  | |   |  ---+");
  typeWriter.addLine("                                                      |");
  typeWriter.addLine("                                                   ---");
  typeWriter.addLine("");
  typeWriter.addLine("-------------------------------------------------- */");

  typeWriter.addLine("TypeWriter typeWriter;");
  typeWriter.addLine("void setup() {");
  typeWriter.addLine("  size(400, 300, P3D);");
  typeWriter.addLine("  typeWriter = new Typer();");
  typeWriter.addLine("  frameRate(20);");
  typeWriter.addLine("  ");
  typeWriter.addLine("  setupTypeWriter();");
  typeWriter.addLine("}");
  typeWriter.addLine("");
  typeWriter.addLine("void draw() {");
  typeWriter.addLine("  background(255);");
  typeWriter.addLine("  ");
  typeWriter.addLine("  typeWriter = typeWriter.update();");
  typeWriter.addLine("}");
  typeWriter.addLine("");
  typeWriter.addLine("ArrayList<String> lines = new ArrayList<String>();");
  typeWriter.addLine("    ");
  typeWriter.addLine("abstract class TypeWriter {");
  typeWriter.addLine("  final int MAX_LINES = 10;  ");
  typeWriter.addLine("  final int FONT_SIZE = 12;");
  typeWriter.addLine("  final int WAIT_TIME = 24;");
  typeWriter.addLine("  final int START_X = 10;");
  typeWriter.addLine("  final int START_Y = 10 + FONT_SIZE;");
  typeWriter.addLine("  ");
  typeWriter.addLine("  int endPosition;");
  typeWriter.addLine("  ");
  typeWriter.addLine("  TypeWriter() {");
  typeWriter.addLine("    endPosition = 0;");
  typeWriter.addLine("  }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  public void addLine(String newLine) {");
  typeWriter.addLine("    addLines(newLine.split(\"\\n\"));");
  typeWriter.addLine("  }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  public void addLines(String[] newLines) {");
  typeWriter.addLine("    for(String line : newLines) lines.add(line);");
  typeWriter.addLine("  }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  protected int getAllStringLength() {");
  typeWriter.addLine("    int len = 0;");
  typeWriter.addLine("    for(String line : lines) len += line.length();");
  typeWriter.addLine("    return len;");
  typeWriter.addLine("  }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  TypeWriter update() {");
  typeWriter.addLine("    pushMatrix();");
  typeWriter.addLine("    camera();");
  typeWriter.addLine("    fill(0);");
  typeWriter.addLine("    ");
  typeWriter.addLine("    TypeWriter ret = display();");
  typeWriter.addLine("    ");
  typeWriter.addLine("    popMatrix();");
  typeWriter.addLine("    return ret;");
  typeWriter.addLine("  }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  protected abstract TypeWriter display();");
  typeWriter.addLine("}");
  typeWriter.addLine("    ");
  typeWriter.addLine("class Typer extends TypeWriter {");
  typeWriter.addLine("  int _endPosition;");
  typeWriter.addLine("");
  typeWriter.addLine("  Typer() { this(0); }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  Typer(int endPosition) {");
  typeWriter.addLine("    _endPosition = endPosition;");
  typeWriter.addLine("  }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  protected TypeWriter display() {");
  typeWriter.addLine("    if(getAllStringLength() == 0) {");
  typeWriter.addLine("      _endPosition = 0;");
  typeWriter.addLine("      return this;");
  typeWriter.addLine("    }");
  typeWriter.addLine("    int textLength = ++_endPosition;");
  typeWriter.addLine("    for(int i = 0; i < min(MAX_LINES, lines.size()); ++i) {");
  typeWriter.addLine("      String line = (textLength < lines.get(i).length()) ? ");
  typeWriter.addLine("        lines.get(i).substring(0, textLength) : lines.get(i);");
  typeWriter.addLine("      ");
  typeWriter.addLine("      text(line, START_X, START_Y + i * FONT_SIZE);");
  typeWriter.addLine("      textLength -= line.length();");
  typeWriter.addLine("      if(!(0 < textLength)) {");
  typeWriter.addLine("        return this;");
  typeWriter.addLine("      }");
  typeWriter.addLine("    }");
  typeWriter.addLine("    return new Waiter(_endPosition -1);");
  typeWriter.addLine("  }");
  typeWriter.addLine("}");
  typeWriter.addLine("");
  typeWriter.addLine("    ");
  typeWriter.addLine("class Waiter extends TypeWriter {");
  typeWriter.addLine("  int _counter;");
  typeWriter.addLine("  int _endPosition;");
  typeWriter.addLine("  Waiter(int endPosition) {");
  typeWriter.addLine("    _counter = 0;");
  typeWriter.addLine("    _endPosition = endPosition;");
  typeWriter.addLine("  }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  protected TypeWriter display() {");
  typeWriter.addLine("    ++_counter;");
  typeWriter.addLine("    for(int i = 0; i < min(MAX_LINES, lines.size()); ++i) {");
  typeWriter.addLine("      String line = lines.get(i);");
  typeWriter.addLine("      text(line, START_X, START_Y + i * FONT_SIZE);");
  typeWriter.addLine("    }");
  typeWriter.addLine("    return WAIT_TIME < _counter || _endPosition < getAllStringLength() ?");
  typeWriter.addLine("      new Elevator(_endPosition) : this;");
  typeWriter.addLine("  }");
  typeWriter.addLine("}");
  typeWriter.addLine("    ");
  typeWriter.addLine("class Elevator extends TypeWriter {");
  typeWriter.addLine("  int _endPosition;");
  typeWriter.addLine("  int _counter;");
  typeWriter.addLine("  Elevator(int endPosition) {");
  typeWriter.addLine("    _endPosition = endPosition;");
  typeWriter.addLine("    _counter = 0;");
  typeWriter.addLine("  }");
  typeWriter.addLine("  ");
  typeWriter.addLine("  protected TypeWriter display() {");
  typeWriter.addLine("    int textLength = ++_endPosition - lines.get(0).length();");
  typeWriter.addLine("    for(int i = 1; i < min(MAX_LINES, lines.size()); ++i) {");
  typeWriter.addLine("      String line = lines.get(i);");
  typeWriter.addLine("      textLength -= line.length();");
  typeWriter.addLine("      text(line, START_X, START_Y + i * FONT_SIZE - _counter);");
  typeWriter.addLine("    }");
  typeWriter.addLine("    if (0 < textLength && MAX_LINES < lines.size()) {");
  typeWriter.addLine("      String line = textLength < lines.get(MAX_LINES).length() ?");
  typeWriter.addLine("        lines.get(MAX_LINES).substring(0, textLength) : lines.get(MAX_LINES);      ");
  typeWriter.addLine("      text(line, START_X, START_Y + (MAX_LINES) * FONT_SIZE - _counter);");
  typeWriter.addLine("    } else  --_endPosition;");
  typeWriter.addLine("    if(++_counter < FONT_SIZE) return this;");
  typeWriter.addLine("    ");
  typeWriter.addLine("    _endPosition -= lines.get(0).length();    ");
  typeWriter.addLine("    if(MAX_LINES < lines.size() && ");
  typeWriter.addLine("       lines.get(MAX_LINES).length() < textLength)");
  typeWriter.addLine("         _endPosition -= (textLength - lines.get(MAX_LINES).length());");
  typeWriter.addLine("    ");
  typeWriter.addLine("    lines.remove(0);");
  typeWriter.addLine("    return new Typer(_endPosition);");
  typeWriter.addLine("  }");
  typeWriter.addLine("}");
}

