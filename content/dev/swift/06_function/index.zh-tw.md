---
title : "[從C#到Swift] 06. Functions"
date: 2026-01-27
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description: "本文深入解析 Swift 函式 (Functions) 的特性，並為 C# 開發者提供詳細對照。涵蓋參數標籤 (Argument Labels)、多重回傳值 (Tuples)、In-Out 參數以及函式作為一級公民 (First-class citizen) 的用法。透過 C# 視角分析語法差異，幫助你快速掌握 Swift 靈活的函式設計模式。"
keywords: ["Swift vs C#", "iOS Development", "Swift Functions", "Argument Labels", "Function Types"]
featureImage: "featureImage.png"
featureImageDescription: "Swift 函式語法結構與 C# 方法定義的對照圖"
slug: "from-csharp-to-swift/functions"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Functions](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions#Functions-With-Multiple-Parameters)

## 定義與呼叫函式 (Defining and Calling Functions)

### 1. 核心觀念
*   **概念解說**：函式是執行特定任務的獨立程式碼區塊。在 Swift 中，函式的語法非常靈活，從類似 C 語言的簡單風格，到類似 Objective-C 帶有詳細參數標籤的風格都能支援。每個函式都有一個型別，由參數型別與回傳型別組成。
*   **關鍵語法**：`func`, `->`, `return`
*   **官方提示**：
> **Note**
> `print(_:separator:terminator:)` 函式的第一個參數沒有標籤，而其他參數因為有預設值所以是選填的。這些語法變化將在後續章節詳細討論。

### 2. 範例解析
**文件原始碼**：
```swift
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}

print(greet(person: "Anna"))
// Prints "Hello, Anna!"
```

**邏輯解說**：
這段程式碼定義了一個名為 `greet` 的函式，它接收一個 `String` 型別的參數 `person`，並回傳一個 `String`。`->` 符號用來指示回傳型別。呼叫時，必須寫出參數標籤 `person: "Anna"`。

### 3. C# 開發者視角

**概念對應**：這相當於 C# 中的 Method 定義。

**C# 對照程式碼**：
```csharp
public string Greet(string person) {
    string greeting = "Hello, " + person + "!";
    return greeting;
}

// 呼叫
Console.WriteLine(Greet("Anna")); // 通常不強制寫參數名
// 或者使用具名引數
Console.WriteLine(Greet(person: "Anna"));
```

**關鍵差異分析**：
*   **語法面**：Swift 使用 `func` 關鍵字，回傳型別寫在箭頭 `->` 之後；C# 則是將回傳型別寫在方法名稱之前。
*   **行為面**：最顯著的差異在於**呼叫習慣**。Swift 預設要求在呼叫時寫出參數標籤（Argument Label），這讓程式碼讀起來像句子；C# 雖然支援具名引數 (Named Arguments)，但慣例上較少強制使用。

---

## 參數與回傳值 (Function Parameters and Return Values)

### 1. 核心觀念
*   **概念解說**：Swift 的參數與回傳值非常彈性。支援無參數、多參數、無回傳值（實際上是回傳 `Void`），以及透過 Tuple 實現多重回傳值。
*   **關鍵語法**：`Void`, `Tuple`, `Optional Tuple`
*   **官方提示**：
> 嚴格來說，沒有定義回傳型別的函式仍然會回傳值。它們回傳一個特殊的 `Void` 型別值，這其實是一個空的 Tuple，寫作 `()`。

### 2. 範例解析
**文件原始碼 (多重回傳值)**：
```swift
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
```

**邏輯解說**：
此範例展示了如何使用 **Tuple** 一次回傳最大值與最小值。同時，回傳型別標記為 `(min: Int, max: Int)?`，表示這是一個「可選的 Tuple」(Optional Tuple)，當陣列為空時可以回傳 `nil`。

### 3. C# 開發者視角

**概念對應**：C# 7.0 引入的 `ValueTuple` 與此非常相似。

**C# 對照程式碼**：
```csharp
// C# 7.0+ Tuple 語法
public (int min, int max)? MinMax(int[] array) {
    if (array.Length == 0) return null;
    
    int currentMin = array[0];
    int currentMax = array[0];
    
    foreach (var value in array.Skip(1)) {
        if (value < currentMin) currentMin = value;
        else if (value > currentMax) currentMax = value;
    }
    return (currentMin, currentMax);
}
```

**關鍵差異分析**：
*   **語法面**：兩者語法驚人地相似。Swift 的 `Void` 對應 C# 的 `void`，但 Swift 的 `Void` 本質上是一個空 Tuple `()`，而 C# 的 void 不是可傳遞的型別。
*   **行為面**：注意 Swift 的 Optional Tuple `(Int, Int)?` 代表**整個 Tuple** 可能不存在；這與 Tuple 內部包含 Optional `(Int?, Int?)` 是不同的概念。C# 的 `Nullable<(int, int)>` 行為類似。

---

## 隱式回傳 (Functions With an Implicit Return)

### 1. 核心觀念
*   **概念解說**：如果函式的本體 (Body) 只有`一行表達式` (Expression)，可以省略 `return` 關鍵字。
*   **關鍵語法**：Implicit Return

### 2. 範例解析
**文件原始碼**：
```swift
func greeting(for person: String) -> String {
    "Hello, " + person + "!"
}
```

**邏輯解說**：
編譯器會自動判斷最後一行的結果作為回傳值，使程式碼更簡潔。

### 3. C# 開發者視角

**概念對應**：相當於 C# 的 **Expression-bodied members**。

**C# 對照程式碼**：
```csharp
public string Greeting(string person) => "Hello, " + person + "!";
```

**關鍵差異分析**：
*   **語法面**：C# 使用 lambda 箭頭 `=>`；Swift 則是直接保留大括號 `{}` 但省略 `return`。
*   **行為面**：兩者概念完全一致，都是為了減少 boilerplate code。

---

## 參數標籤與名稱 (Function Argument Labels and Parameter Names)

### 1. 核心觀念
*   **概念解說**：這是 Swift 最具特色的設計之一。每個參數有兩個名字：
    1.  **Argument Label (參數標籤)**：在**呼叫**函式時使用，目的是讓呼叫語句讀起來像自然語言。
    2.  **Parameter Name (參數名稱)**：在**函式內部**實作時使用。
*   **關鍵語法**：`ArgumentLabel ParameterName: Type`, `_` (省略標籤)

### 2. 範例解析
**文件原始碼**：
```swift
// 指定標籤：呼叫用 from，內部用 hometown
func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))

// 省略標籤：使用 _
func someFunction(_ firstParameterName: Int, secondParameterName: Int) { ... }
someFunction(1, secondParameterName: 2)
```

**邏輯解說**：
`greet` 函式透過 `from` 讓呼叫端 `greet(..., from: "Cupertino")` 讀起來極為流暢。若不希望強制寫標籤，可使用底線 `_` 來省略，這在模仿 C 語言風格函式庫時很有用。

### 3. C# 開發者視角

**概念對應**：C# 沒有直接對應的「內外分立」命名機制，C# 的參數名稱同時用於內部實作與具名引數呼叫。

**C# 對照程式碼**：
```csharp
// C# 無法完全模擬 Swift 的 "from hometown" 語法
// 只能透過參數命名來盡量表達語意
public string Greet(string person, string from) {
    return $"Hello {person}! Glad you could visit from {from}.";
}

// 呼叫
Greet(person: "Bill", from: "Cupertino");
```

**關鍵差異分析**：
*   **語法面**：Swift 允許 `func f(label name: Type)`，C# 只有 `void f(Type name)`。
*   **設計哲學**：Swift 強調 **API 的可讀性** (Call-site readability)，將「讀起來像英文句子」視為最高指導原則（源自 Objective-C 的遺產）。C# 開發者剛接觸時可能會覺得多寫一個標籤很冗餘，但習慣後會發現這對程式碼的自我解釋性 (Self-documenting) 極有幫助。

---

## 預設參數值 (Default Parameter Values)

### 1. 核心觀念
*   **概念解說**：可以在定義函式時為參數提供預設值。呼叫時若省略該參數，則使用預設值。
*   **關鍵語法**：`param: Type = value`

### 2. 範例解析
**文件原始碼**：
```swift
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // ...
}
someFunction(parameterWithoutDefault: 4) // parameterWithDefault 使用 12
```

### 3. C# 開發者視角

**概念對應**：完全對應 C# 的 **Optional Arguments**。

**C# 對照程式碼**：
```csharp
void SomeFunction(int parameterWithoutDefault, int parameterWithDefault = 12) { ... }
```

**關鍵差異分析**：
*   **行為面**：兩者機制幾乎相同。但在 Swift 中，通常建議將沒有預設值的參數放在前面，有預設值的放在後面（雖然 Swift 語法不強制，但這是好習慣），這一點與 C# 的規定（選用參數必須在必填參數之後）是一致的。

---

## 可變參數 (Variadic Parameters)

### 1. 核心觀念
*   **概念解說**：允許函式接收零個或多個特定型別的值。目前僅允許一個 Variadic 參數，且必須放在參數列表的最後
*   **關鍵語法**：`Type...`

### 2. 範例解析
**文件原始碼**：
```swift
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
```

**邏輯解說**：
`numbers` 在函式內部會被視為一個 `[Double]` 陣列。

### 3. C# 開發者視角

**概念對應**：對應 C# 的 `params` 關鍵字。

**C# 對照程式碼**：
```csharp
public double ArithmeticMean(params double[] numbers) {
    double total = 0;
    foreach (var number in numbers) {
        total += number;
    }
    return total / numbers.Length;
}
```

**關鍵差異分析**：
*   **語法面**：Swift 使用後綴 `...`，C# 使用前綴 `params` 關鍵字。
*   **行為面**：Swift 目前僅允許一個 Variadic 參數，且必須放在參數列表的最後；C# 也有類似限制。

---

## In-Out 參數 (In-Out Parameters)

### 1. 核心觀念
*   **概念解說**：預設情況下，Swift 的函式參數是**常數 (Constant)**，不可在函式內修改。若需要修改傳入的變數並將結果反映回原變數，需使用 `inout`。
*   **關鍵語法**：`inout`, `&`
*   **官方提示**：
> In-out 參數不能有預設值，且 Variadic 參數不能標記為 `inout`。

### 2. 範例解析
**文件原始碼**：
```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
```

**邏輯解說**：
`inout` 關鍵字標示參數可被修改。在呼叫時，變數前必須加上 `&` 符號，明確表示這裡發生了記憶體位址/值的傳遞引用。

### 3. C# 開發者視角

**概念對應**：對應 C# 的 `ref` 關鍵字。

**C# 對照程式碼**：
```csharp
public void SwapTwoInts(ref int a, ref int b) {
    int temporaryA = a;
    a = b;
    b = temporaryA;
}

int someInt = 3;
int anotherInt = 107;
SwapTwoInts(ref someInt, ref anotherInt);
```

**關鍵差異分析**：
*   **語法面**：Swift 定義時用 `inout`，呼叫時用 `&`；C# 定義與呼叫都使用 `ref`。
*   **行為面**：兩者概念一致，都是為了讓 Value Type (如 Struct, Int) 能像 Reference Type 一樣被修改。注意 Swift 的 `inout` 行為在底層優化上稱為 "Copy-in Copy-out" (或是 Call by value result)，在多執行緒環境下可能與 C# 的直接記憶體位置引用 (`ref`) 行為有細微差異，但一般使用上可視為相同。

---

## 函式型別 (Function Types)

### 1. 核心觀念
*   **概念解說**：在 Swift 中，函式是**一級公民 (First-class citizen)**。函式本身有型別，可以被指派給變數、作為參數傳遞，或作為回傳值。
*   **關鍵語法**：`(ParamTypes) -> ReturnType`

### 2. 範例解析
**文件原始碼**：
```swift
func addTwoInts(_ a: Int, _ b: Int) -> Int { a + b }

// 定義變數 mathFunction，其型別為「接受兩個 Int 並回傳 Int 的函式」
var mathFunction: (Int, Int) -> Int = addTwoInts
print("Result: \(mathFunction(2, 3))")

// 函式作為參數
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
```

**邏輯解說**：
`mathFunction` 變數儲存了 `addTwoInts` 函式的參考。這讓你可以動態抽換執行邏輯。

### 3. C# 開發者視角

**概念對應**：對應 C# 的 **Delegates** (`Func<>`, `Action<>`)。

**C# 對照程式碼**：
```csharp
int AddTwoInts(int a, int b) => a + b;

// 使用 Func 委派
Func<int, int, int> mathFunction = AddTwoInts;
Console.WriteLine($"Result: {mathFunction(2, 3)}");

// 函式作為參數
public void PrintMathResult(Func<int, int, int> mathFunc, int a, int b) {
    Console.WriteLine($"Result: {mathFunc(a, b)}");
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的語法 `(Int, Int) -> Int` 比 C# 的 `Func<int, int, int>` 更直觀且易讀。
*   **行為面**：本質相同，都是指向程式碼區塊的參考。Swift 的語法糖讓 Functional Programming 的模式更容易被接受與實作。

---

## 巢狀函式 (Nested Functions)

### 1. 核心觀念
*   **概念解說**：可以在一個函式內部定義另一個函式。內層函式可以存取外層函式的變數（閉包特性），並且可以被回傳給外部使用。
*   **關鍵語法**：Function scope

### 2. 範例解析
**文件原始碼**：
```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
```

**邏輯解說**：
`stepForward` 與 `stepBackward` 被隱藏在 `chooseStepFunction` 內部，外部無法直接呼叫它們，保持了全域命名空間的乾淨。但它們可以作為回傳值傳遞出去。

### 3. C# 開發者視角

**概念對應**：對應 C# 7.0 引入的 **Local Functions**。

**C# 對照程式碼**：
```csharp
public Func<int, int> ChooseStepFunction(bool backward) {
    int StepForward(int input) => input + 1;
    int StepBackward(int input) => input - 1;
    
    return backward ? (Func<int, int>)StepBackward : StepForward;
}
```

**關鍵差異分析**：
*   **語法面**：結構幾乎一樣。
*   **行為面**：兩者都支援 Closure (閉包) 特性，即內部函式可以捕獲 (Capture) 外部函式的變數狀態。這在撰寫複雜的演算法或遞迴邏輯時，能有效封裝輔助函式。