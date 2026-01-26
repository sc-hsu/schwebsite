---
title : "[從C#到Swift] 05. Control Flow"
date : 2026-01-26
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description : "深入解析 Swift 的控制流程語法，涵蓋 For-In 迴圈、強大的 Switch 模式匹配、Guard 提前退出機制以及 Defer 資源管理。本文專為 C# 開發者設計，透過詳細的代碼對照與行為分析，協助您快速掌握 Swift 獨有的流程控制特性與語法差異。"
keywords : ["Swift vs C#", "iOS Development", "Pattern Matching", "Guard vs If", "Defer statement"]
featureImage : "conver.jpg"
featureImageDescription : "Swift 標誌與流程圖的抽象結合，象徵程式碼的執行路徑控制"
slug : "from-csharp-to-swift/control-flosw"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Control Flow](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/controlflow)


## For-In 迴圈 (For-In Loops)

### 1. 核心觀念
*   **概念解說**：`for-in` 是 Swift 中最主要的遍歷語法。它用來遍歷序列（Sequence），例如陣列（Array）、字典（Dictionary）、數值範圍（Range）或字串（String）。它的語法比 C 語言風格的 `for` 迴圈更簡潔且安全。
*   **關鍵語法**：`for-in`, `...` (閉區間), `..<` (半開區間), `stride`, `_` (忽略值)
*   **官方提示**：
> 字典（Dictionary）的內容本質上是無序的，因此遍歷它們並不保證檢索順序。這與插入順序無關。

### 2. 範例解析
**文件原始碼**：
```swift
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}

let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}

for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
```

**邏輯解說**：
1.  第一段展示遍歷陣列，`name` 是每次迭代中的常數。
2.  第二段展示遍歷字典，Swift 將字典的每個元素視為一個 `(key, value)` 的 Tuple，我們可以直接在迴圈宣告時進行解構（Decomposition）。
3.  第三段展示數值範圍遍歷，使用 `...` 運算符表示包含頭尾的範圍。

### 3. C# 開發者視角

**概念對應**：相當於 C# 的 `foreach` 迴圈。

**C# 對照程式碼**：
```csharp
var names = new[] { "Anna", "Alex", "Brian", "Jack" };
foreach (var name in names) {
    Console.WriteLine($"Hello, {name}!");
}

var numberOfLegs = new Dictionary<string, int> { {"spider", 8}, {"ant", 6}, {"cat", 4} };
foreach (var kvp in numberOfLegs) { // C# 透過 KeyValuePair 存取
    Console.WriteLine($"{kvp.Key}s have {kvp.Value} legs");
}
// 或是 C# 7.0+ 解構
foreach (var (animal, legs) in numberOfLegs) {
    Console.WriteLine($"{animal}s have {legs} legs");
}

foreach (var index in Enumerable.Range(1, 5)) {
    Console.WriteLine($"{index} times 5 is {index * 5}");
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的區間運算符 `1...5` (閉區間) 和 `0..<5` (不包含尾端) 非常直觀。C# 通常需要使用 `Enumerable.Range` 或傳統 `for` 迴圈。
*   **行為面**：Swift 的 `for-in` 中的迭代變數（如 `index`）預設是**常數 (let)**，在迴圈內不可修改。若不需要該變數，Swift 要求使用 _ 明確忽略未使用的值，主要目的是提升可讀性與避免誤用；是否產生實質效能優化則由編譯器決定。

---

## While 迴圈 (While Loops)

### 1. 核心觀念
*   **概念解說**：當迭代次數未知，直到特定條件滿足前需要重複執行時使用。Swift 提供兩種形式：`while` (先檢查條件) 和 `repeat-while` (後檢查條件)。
*   **關鍵語法**：`while`, `repeat-while`
*   **官方提示**：
> Swift 的 `repeat-while` 迴圈類似於其他語言中的 `do-while` 迴圈。

### 2. 範例解析
**文件原始碼**：
```swift
// While
while square < finalSquare {
    // 遊戲邏輯...
    square += diceRoll
}

// Repeat-While
repeat {
    // 遊戲邏輯...
    square += diceRoll
} while square < finalSquare
```

**邏輯解說**：這段代碼演示了「蛇梯棋」遊戲的邏輯。`while` 會在執行區塊前先判斷條件；而 `repeat-while` 保證區塊內的程式碼至少執行一次，最後才檢查條件。

### 3. C# 開發者視角

**概念對應**：完全對應 C# 的 `while` 和 `do-while`。

**C# 對照程式碼**：
```csharp
// C#
while (square < finalSquare) {
    // Logic
}

do {
    // Logic
} while (square < finalSquare);
```

**關鍵差異分析**：
*   **語法面**：Swift 使用關鍵字 `repeat` 來替代 C# 的 `do`。
*   **行為面**：行為邏輯完全一致。主要差異在於 Swift 的條件判斷式不需要像 C# 一樣強制加上小括號 `()`，例如 `while square < finalSquare` 即可。

---

## 條件判斷 (Conditional Statements)

### 1. 核心觀念
*   **概念解說**：Swift 的 `if` 不僅是語句，也可以作為表達式（Expression）回傳值。`switch` 則比 C# 傳統的 switch 強大許多，支援區間、Tuple 和模式匹配。
*   **關鍵語法**：`if`, `else if`, `else`

### 2. 範例解析
**文件原始碼**：
```swift
// 標準用法
if temperatureInFahrenheit <= 32 {
    print("It's very cold.")
}

// If Expression (賦值用法)
let weatherAdvice = if temperatureInCelsius <= 0 {
    "It's very cold. Consider wearing a scarf."
} else if temperatureInCelsius >= 30 {
    "It's really warm. Don't forget to wear sunscreen."
} else {
    "It's not that cold. Wear a T-shirt."
}
```

**邏輯解說**：這裡展示了將 `if` 當作表達式使用，直接將判斷結果賦值給變數 `weatherAdvice`。這讓程式碼更簡潔，不需要先宣告變數再賦值。

### 3. C# 開發者視角

**概念對應**：
*   標準 `if` 對應 C# `if`。
*   `if` 表達式對應 C# 的三元運算子 `? :` 或較新的 Switch Expression。

**C# 對照程式碼**：
```csharp
// C# 使用三元運算子達到類似 if expression 效果
var weatherAdvice = temperatureInCelsius <= 0 ? "It's very cold..." 
    : temperatureInCelsius >= 30 ? "It's really warm..." 
    : "It's not that cold...";
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `if` 條件不需要小括號 `()` 包覆，但執行區塊的大括號 `{}` 是**強制**的（即使只有一行代碼）。C# 允許單行省略大括號，Swift 不行。
*   **行為面**：Swift的 `if` 表達式比 C# 的巢狀三元運算子更具可讀性。

---

## Switch 語句 (Switch)

### 1. 核心觀念
*   **概念解說**：Swift 的 `switch` 極為強大。它必須是**窮舉的 (Exhaustive)**，也就是所有可能的情況都必須被處理（通常透過 `default`）。最重要的一點是：**預設不貫穿 (No Implicit Fallthrough)**。
*   **關鍵語法**：`switch`, `case`, `default`, `...` (區間匹配), `(a, b)` (Tuple 匹配), `let` (數值綁定), `where` (額外條件)
*   **官方提示**：
> 雖然在 Swift 中 `break` 不是必須的，但你可以使用 `break` 語句來匹配並忽略某個特定的 case，或是用來提前跳出執行。
> 若需要 C 語言風格的貫穿行為，必須顯式使用 `fallthrough` 關鍵字。

### 2. 範例解析
**文件原始碼**：
```swift
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("origin")
case (_, 0): // 匹配任何 x 值，y 為 0
    print("on the x-axis")
case (0, _): // 匹配 x 為 0，任何 y 值
    print("on the y-axis")
case (-2...2, -2...2): // 區間匹配
    print("inside the box")
default:
    print("outside")
}

// 數值綁定與 Where 子句
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("on the line x == y")
case let (x, y) where x == -y:
    print("on the line x == -y")
case let (x, y):
    print("arbitrary point (\(x), \(y))")
}
```

**邏輯解說**：
1.  第一個範例展示了 Tuple 匹配和萬用字元 `_`。Swift 可以同時比對多個值。
2.  第二個範例展示了「數值綁定」(Value Binding)，將匹配到的值暫存為常數 `x`, `y`，並透過 `where` 子句加上額外的邏輯判斷。

### 3. C# 開發者視角

**概念對應**：類似 C# 的 `switch`，尤其是 C# 8.0+ 引入的 Pattern Matching。

**C# 對照程式碼**：
```csharp
// C# 8.0+ Pattern Matching
var somePoint = (1, 1);
switch (somePoint) {
    case (0, 0):
        Console.WriteLine("origin");
        break;
    case (var x, 0): // 類似 Swift 的 (_, 0) 但語法稍有不同
        Console.WriteLine($"on x-axis at {x}");
        break;
    case (0, _):
        Console.WriteLine("on y-axis");
        break;
    case (var x, var y) when x == y: // 對應 Swift 的 case let ... where
        Console.WriteLine("x == y");
        break;
    default:
        Console.WriteLine("outside");
        break;
}
```

**關鍵差異分析**：
*   **語法面**：Swift 不需要寫 `break`，這是最大的習慣差異。C# 即使是空的 case 也不能直接貫穿到下一個非空 case（除非用 `goto case`），Swift 則完全禁止隱式貫穿。
*   **行為面**：Swift 的 `switch` 必須處理所有可能性，這對 Enum 特別有用，當 Enum 新增成員時，編譯器會強迫你更新 switch 代碼，減少 Bug。
*   **複合 Case**：Swift 支援 `case "a", "b":` 這種寫法；C# 傳統上是堆疊 case 標籤，現代模式匹配也支援 `or` 邏輯。

---

## 控制轉移語句 (Control Transfer Statements)

### 1. 核心觀念
*   **概念解說**：改變程式執行順序的語句。包括 `continue` (跳過本次迴圈)、`break` (跳出迴圈或 switch)、`fallthrough` (switch 貫穿)。
*   **關鍵語法**：`continue`, `break`, `fallthrough`, `return`, `throw`

### 2. 範例解析
**文件原始碼**：
```swift
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough // 顯式要求貫穿
default:
    description += " an integer."
}
// 結果: "The number 5 is a prime number, and also an integer."
```

**邏輯解說**：因為 Swift switch 預設匹配到一個 case 就會結束，若希望執行完 case 1 後繼續執行 case 2 (或 default) 的代碼，必須加上 `fallthrough`。

### 3. C# 開發者視角

**概念對應**：
*   `continue` / `break` 與 C# 行為一致。
*   `fallthrough` 對應 C# 的 `goto case` 或 `goto default`。

**C# 對照程式碼**：
```csharp
switch (integerToDescribe) {
    case 2:
    case 3:
    // ...
    case 19:
        description += " a prime number, and also";
        goto default; // C# 的顯式貫穿
    default:
        description += " an integer.";
        break;
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `fallthrough` 不需要指定跳轉的目標，它直接「掉進」下一個 case 的執行區塊中，**且不會檢查下一個 case 的條件**，這點非常重要且容易產生 Bug，需謹慎使用。

---

## 帶標籤的語句 (Labeled Statements)

### 1. 核心觀念
*   **概念解說**：當有多層巢狀迴圈時，可以使用標籤（Label）來指定 `break` 或 `continue` 作用於哪一層迴圈。
*   **關鍵語法**：`labelName: while ...`

### 2. 範例解析
**文件原始碼**：
```swift
gameLoop: while square != finalSquare {
    diceRoll += 1
    switch square + diceRoll {
    case finalSquare:
        break gameLoop // 直接跳出最外層的 while 迴圈，而不只是 switch
    // ...
    }
}
```

**邏輯解說**：如果不加標籤，`break` 只會跳出 `switch` 語句。加上 `gameLoop` 標籤後，`break gameLoop` 會直接終止整個 `while` 迴圈。

### 3. C# 開發者視角

**概念對應**：C# 也有 `goto` 標籤，但沒有這種直接綁定在迴圈結構上的 `break label` 語法。

**C# 對照程式碼**：
```csharp
// C# 通常做法
bool keepPlaying = true;
while (keepPlaying) {
    // ...
    switch (condition) {
        case 1:
            keepPlaying = false; // 使用旗標
            break; 
        // 或者使用 goto
        case 2:
            goto EndOfLoop;
    }
}
EndOfLoop: ;
```

**關鍵差異分析**：
*   **語法面** : Swift 的標籤語法比 C# 的 `goto` 更結構化且易讀，專門用於巢狀迴圈控制。

---

## 提前退出 (Guard)

### 1. 核心觀念
*   **概念解說**：`guard` 是一種「反向 if」。它要求條件**必須為真**，否則執行 `else` 區塊。`else` 區塊內**必須**包含退出當前範圍的指令（如 `return`, `break`, `throw`）。這能避免「箭頭型代碼」（過度巢狀的 if），讓快樂路徑（Happy Path）保持在最外層。
*   **關鍵語法**：`guard condition else { return }`

### 2. 範例解析
**文件原始碼**：
```swift
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return // 條件不符，必須退出
    }
    // name 在這裡可以直接使用，不需要在 else 區塊內
    print("Hello \(name)!")
    
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}
```

**邏輯解說**：
1.  檢查 `person["name"]` 是否有值。
2.  如果沒值，進入 `else` 並返回。
3.  如果有值，解包後的 `name` 變數可以在 `guard` 語句**之後**的代碼中直接使用（這是與 `if let` 最大的不同）。

### 3. C# 開發者視角

**概念對應**：C# 沒有 `guard` 關鍵字。通常使用「反向 if」模式（Guard Clauses pattern）。

**C# 對照程式碼**：
```csharp
void Greet(Dictionary<string, string> person) {
    if (!person.TryGetValue("name", out var name)) {
        return;
    }
    // C# out 變數洩漏到外部範圍，類似 guard 的效果
    Console.WriteLine($"Hello {name}!");
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `guard` 強制要求 `else` 區塊必須退出，這在編譯時期就能保證安全性。C# 只是依賴開發者的編碼習慣。
*   **範圍**：`guard let` 綁定的變數作用域是 guard 語句所在的整個區塊（直到結尾），這讓代碼閱讀起來非常流暢。

---

## 延遲執行 (Defer)

### 1. 核心觀念
*   **概念解說**：`defer` 區塊中的代碼會在「當前範圍（Scope）結束前」執行，無論是因為成功執行完畢、return 返回還是拋出錯誤。通常用於資源清理（如關閉檔案、釋放鎖）。
*   **關鍵語法**：`defer { ... }`

### 2. 範例解析
**文件原始碼**：
```swift
var score = 1
if score < 10 {
    defer {
        print(score)
    }
    score += 5
}
// Prints "6"
```

**邏輯解說**：
1.  進入 `if`。
2.  宣告 `defer`，這裡的 print 被推入堆疊，等待離開範圍時執行。
3.  執行 `score += 5`，score 變為 6。
4.  準備離開 `if` 範圍，執行 `defer` 區塊，印出 6。

### 3. C# 開發者視角

**概念對應**：類似 C# 的 `try-finally` 區塊或 `using` 語句（`IDisposable`）。

**C# 對照程式碼**：
```csharp
// C# 使用 try-finally 模擬
{
    try {
        score += 5;
    } finally {
        Console.WriteLine(score);
    }
}

// 或使用 using (若涉及資源釋放)
using (var resource = new Resource()) {
    // code
} // Dispose called here
```

**關鍵差異分析**：
*   **靈活性**：`defer` 不需要物件實作介面，也不需要層層包裹的 `try-finally`。你可以隨時隨地在代碼中間插入一個 `defer` 來處理清理工作，且多個 `defer` 會以 **LIFO (後進先出)** 的順序執行。

---

## API 可用性檢查 (Checking API Availability)

### 1. 核心觀念
*   **概念解說**：由於 iOS/macOS 更新頻繁，Swift 的 #available 是編譯期與執行期協作的機制。
*   **關鍵語法**：`#available`, `#unavailable`

### 2. 範例解析
**文件原始碼**：
```swift
if #available(iOS 10, macOS 10.12, *) {
    // 使用新 API
} else {
    // 使用舊 API
}
```

**邏輯解說**：`*` 代表除了前面列出的平台外，其他平台的最低部署目標。編譯器會根據這個判斷，允許你在 `if` 區塊內使用較新的 API。

### 3. C# 開發者視角

**概念對應**：C# 的 OperatingSystem 類別檢查 (Runtime) 或 #if 預處理器指令 (Compile time)。

**C# 對照程式碼**：
```csharp
// C# Runtime Check (類似)
if (OperatingSystem.IsIOSVersionAtLeast(10)) {
    // Call new API
}
```

**關鍵差異分析**：
*   **行為面**：Swift 的 #available 與編譯器深度整合。如果你在 #available 區塊外呼叫了新版 API，Swift 編譯器會直接報錯，強迫你加上檢查。C# 的檢查通常是 Runtime 的，編譯器不一定會阻止你在舊系統呼叫新方法（除非使用特定的 Analyzer）。