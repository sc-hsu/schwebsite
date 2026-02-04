---
draft : true
title : "[從C#到Swift] 07. Closures"
date: 2026-01-27T18:00:00+08:00
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description : "本篇深入解析 Swift 閉包 (Closures)，從基本語法優化到尾隨閉包 (Trailing Closures) 與值捕獲。針對 C# 開發者，對比 Lambda Expressions 與 Delegates 的異同，並詳細說明 @escaping 與 @autoclosure 的使用場景，助你快速掌握 Swift 的函數式編程核心。"
keywords : ["Swift vs C#", "iOS Development", "Trailing Closure", "Escaping Closure", "Autoclosure"]
featureImage : "cover.jpg"
featureImageDescription : "Swift 閉包語法結構示意圖"
slug: "from-csharp-to-swift/closures"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Cloures](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures)


## 閉包基礎 (Closure Expressions)

### 1. 核心觀念
* **概念解說**：
    閉包 (Closures) 是自包含的程式碼區塊，可以在程式碼中被傳遞和使用。簡單來說，它就是一段「可以被變數儲存的邏輯」。Swift 的閉包可以捕獲 (Capture) 其定義上下文中的常數和變數。
    Swift 的閉包表達式擁有極簡的語法風格，編譯器能進行強大的型別推斷，允許省略參數型別、括號，甚至使用簡寫參數名 (`$0`)。
* **關鍵語法**：`{ (parameters) -> ReturnType in statements }`、`in` 關鍵字、`$0`、`Trailing Closures`
* **官方提示**：
> Global functions (全域函式) 和 Nested functions (巢狀函式) 其實都是閉包的特例。Global functions 是有名字但不捕獲值的閉包；Nested functions 是有名字且能從外層函式捕獲值的閉包。

### 2. 範例解析
**文件原始碼**：
```swift
// 原始完整寫法
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

// 優化 1: 型別推斷 (Type Inference)
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

// 優化 2: 單一表達式隱式回傳 (Implicit Returns)
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

// 優化 3: 參數簡寫 (Shorthand Argument Names)
reversedNames = names.sorted(by: { $0 > $1 } )

// 優化 4: 運算子方法 (Operator Methods)
reversedNames = names.sorted(by: >)
```

**邏輯解說**：
這段程式碼展示了 Swift 閉包語法的演進過程。從最完整的函式型別宣告，一步步省略已知資訊。
1. 因為 `sorted(by:)` 預期接收 `(String, String) -> Bool`，所以參數型別 `String` 可以省略。
2. 閉包內只有一行程式碼，`return` 關鍵字可以省略。
3. 如果懶得命名參數 `s1`, `s2`，可以直接用 `$0`, `$1` 代表第一個與第二個參數。
4. 因為 String 定義了 `>` 運算子，且其簽章剛好符合需求，可以直接傳入運算子。

### 3. C# 開發者視角

**概念對應**：
Swift 的 Closures 直接對應 C# 的 **Lambda Expressions** (`=>`) 以及 **Anonymous Methods** (`delegate { }`)。

**C# 對照程式碼**：
```csharp
var names = new List<string> { "Chris", "Alex", "Ewa", "Barry", "Daniella" };

// C# Lambda 表達式
// 對應 Swift 的 { s1, s2 in s1 > s2 }
var reversedNames = names.OrderByDescending(s => s).ToList();

// 若要完全模擬比較器邏輯：
names.Sort((s1, s2) => s2.CompareTo(s1)); 
```

**關鍵差異分析**：
*   **語法面**：
    *   Swift 使用 `in` 關鍵字來分隔參數與本體 (`{ params in body }`)。
    *   C# 使用 Lambda 運算子 `=>` (`params => body`)。
    *   Swift 提供 `$0`, `$1` 這種簡寫參數，C# 必須明確命名參數 (例如 `x => x + 1`)，無法省略參數名。
*   **行為面**：
    *   兩者在型別推斷上都非常強大，通常不需要顯式宣告參數型別。

---

## 尾隨閉包 (Trailing Closures)

### 1. 核心觀念
* **概念解說**：
    如果函式的**最後一個參數**是閉包，Swift 允許你將閉包表達式寫在函式呼叫的括號 `()` 之外。這能讓程式碼看起來更像原生的控制結構 (如 `if` 或 `while` 區塊)，大幅提升可讀性。如果閉包是該函式的唯一參數，甚至連括號 `()` 都可以省略。
* **關鍵語法**：`funcName() { ... }`

### 2. 範例解析
**文件原始碼**：
```swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body
}

// 不使用尾隨閉包
someFunctionThatTakesAClosure(closure: {
    // closure's body
})

// 使用尾隨閉包 (括號外)
someFunctionThatTakesAClosure() {
    // trailing closure's body
}

// 實際應用：Array map
let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
```

**邏輯解說**：
`map` 函式接受一個閉包作為參數。因為它是唯一參數，呼叫時省略了 `map(...)` 的括號，直接接上 `{ ... }`。這使得這段轉換邏輯看起來非常像一個獨立的程式區塊，而不是一個函式參數，這是 Swift 打造 DSL (領域特定語言) 感覺的關鍵特性。

### 3. C# 開發者視角

**概念對應**：
C# **沒有**直接對應 Trailing Closures 的語法糖。在 C# 中，即使 Lambda 是最後一個參數，也必須寫在括號內。

**C# 對照程式碼**：
```csharp
// C# 必須將 Lambda 包在括號內
var strings = numbers.Select(number => {
    var tempNumber = number;
    var output = "";
    // ... 邏輯 ...
    return output;
});
```

**關鍵差異分析**：
*   **語法面**：這是 Swift 程式碼看起來比較「乾淨」的主因之一。C# 開發者在閱讀 Swift UI (SwiftUI) 或設定檔程式碼時，會發現大量的 Trailing Closure，要習慣這種「函式呼叫看起來像區塊定義」的寫法。

---

## 值捕獲 (Capturing Values) 與 記憶體管理

### 1. 核心觀念
* **概念解說**：
    閉包可以「捕獲」其定義範圍內的常數或變數，即使定義這些變數的原作用域已經結束，閉包依然可以參考並修改這些值。
    Swift 的閉包是 **Reference Type (參考型別)**。當你將閉包賦值給變數時，你賦值的是參考。
* **關鍵語法**：Reference Type, Capture List, `makeIncrementer`
* **官方提示**：
> 如果你將閉包賦值給類別實例的屬性，而該閉包又捕獲了該實例 (透過 `self`)，會造成 Strong Reference Cycle (強參考循環)。Swift 使用 Capture List (`[weak self]`) 來打破這種循環。

### 2. 範例解析
**文件原始碼**：
```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen() // returns 10
incrementByTen() // returns 20
```

**邏輯解說**：
`incrementer` 函式是巢狀在 `makeIncrementer` 裡面的。它捕獲了外層的 `runningTotal` 和 `amount`。即使 `makeIncrementer` 執行完畢返回了，`runningTotal` 的記憶體空間依然存在，因為 `incrementByTen` 這個閉包捕獲了 `runningTotal` 的儲存狀態，該狀態會隨閉包生命週期一同存在。

### 3. C# 開發者視角

**概念對應**：
這與 C# 的 **Closure 變數捕獲** 機制幾乎完全相同。C# 編譯器會自動生成一個隱藏的類別 (Display Class) 來保存被捕獲的變數。

**C# 對照程式碼**：
```csharp
Func<int> MakeIncrementer(int amount) {
    int runningTotal = 0;
    return () => {
        runningTotal += amount;
        return runningTotal;
    };
}

var incrementByTen = MakeIncrementer(10);
Console.WriteLine(incrementByTen()); // 10
```

**關鍵差異分析**：
*   **行為面 (記憶體管理)**：這是最大的陷阱。
    *   **C#** 使用 Garbage Collection (GC)。即使 Lambda 捕獲了 `this`，通常只要外部沒有參考，循環參考會被 GC 回收 (除非涉及到 Event Handler 等特定場景)。
    *   **Swift** 使用 ARC (Automatic Reference Counting)。閉包預設會對捕獲的物件建立 **Strong Reference**。如果閉包捕獲了 `self`，而 `self` 又持有這個閉包 (例如儲存為屬性)，會導致 **Memory Leak**。C# 開發者寫 Swift 時，必須時刻注意是否需要使用 `[weak self]` 或 `[unowned self]`。

---

## 逃逸閉包 (Escaping Closures)

### 1. 核心觀念
* **概念解說**：
    當一個閉包作為參數傳遞給函式，但在函式返回 **之後** 才被呼叫，這個閉包就稱為「逃逸 (Escape)」。最常見的場景是**非同步操作的 Completion Handler**。
    在 Swift 中，閉包預設是 **Non-Escaping** (不逃逸) 的，這是一種效能優化。如果閉包需要逃逸，必須明確加上 `@escaping` 標籤。
* **關鍵語法**：`@escaping`, `completionHandler`

### 2. 範例解析
**文件原始碼**：
```swift
var completionHandlers: [() -> Void] = []

func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    // 閉包被儲存在外部陣列，稍後才執行 -> 逃逸
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    // 閉包在函式內直接執行完畢 -> 不逃逸
    closure()
}
```

**邏輯解說**：
`someFunctionWithEscapingClosure` 將閉包加入到外部定義的 `completionHandlers` 陣列中。這意味著當函式執行結束後，閉包還存在於記憶體中，隨時可能被呼叫。編譯器強制要求標記 `@escaping`，提醒開發者這裡有潛在的記憶體管理風險 (特別是捕獲 `self` 時)。

### 3. C# 開發者視角

**概念對應**：
C# 沒有 `@escaping` 這種顯式區分。在 C# 中，所有的 Delegate/Lambda 都是物件 (Heap Allocated)，本質上都具備「逃逸」的能力。

**關鍵差異分析**：
*   **語法面**：`@escaping` 是 Swift 特有的語法強制要求。
*   **行為面**：Swift 預設 Non-Escaping 是為了優化 (可以分配在 Stack 上，不需要 Reference Counting)。C# 開發者需要習慣：如果你的 Callback 是非同步執行的，或者被儲存起來以後用，Swift 編譯器會報錯要求你加上 `@escaping`。
*   **Self 的處理**：對於 `@escaping` 閉包，Swift 強制要求在閉包內顯式寫出 `self.` (例如 `self.x`)，或是透過 Capture List 加入 `[self]`，目的是強迫開發者意識到這裡發生了捕獲，防止循環參考。

---

## 自動閉包 (Autoclosures)

### 1. 核心觀念
* **概念解說**：
    `@autoclosure` 是一種語法糖，它會自動將你傳入的「表達式」包裹成一個閉包，只能包裹「單一表達式」，不能是任意程式區塊，但不需要寫花括號 `{}`，。它通常用於 **延遲執行 (Delayed Evaluation)**。
* **關鍵語法**：`@autoclosure`
* **官方提示**：
> 過度使用 `@autoclosure` 會降低程式碼可讀性。使用者可能不知道傳入的參數不會立即被求值。

### 2. 範例解析
**文件原始碼**：
```swift
// 定義接受 autoclosure 的函式
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}

var customersInLine = ["Ewa", "Barry", "Daniella"]

// 呼叫時看起來像傳入 String，但其實是傳入一個閉包
// customersInLine.remove(at: 0) 這行程式碼在 serve 內部呼叫 customerProvider() 時才會執行
serve(customer: customersInLine.remove(at: 0))
```

**邏輯解說**：
`serve` 函式的參數型別標記了 `@autoclosure`。當我們呼叫 `serve(customer: customersInLine.remove(at: 0))` 時，Swift 並不會先執行 `remove(at: 0)` 然後傳結果進去，而是自動生成一個 `{ customersInLine.remove(at: 0) }` 的閉包傳進去。這意味著如果 `serve` 函式內部決定不呼叫這個閉包，`remove` 動作就永遠不會發生。

### 3. C# 開發者視角

**概念對應**：
這類似於 C# 的 `Func<T>` 或 `Lazy<T>`，但 C# 沒有自動將表達式轉為 `Func<T>` 的語法糖。C# 開發者最接近的體驗可能是 `IQueryable` 或 `Expression Tree` 的延遲執行，或是 `Debug.Assert` 的條件檢查。

**C# 對照程式碼**：
```csharp
// C# 沒有 Autoclosure，必須顯式傳入 Func
void Serve(Func<string> customerProvider) {
    Console.WriteLine($"Now serving {customerProvider()}!");
}

// 呼叫時必須寫成 Lambda
Serve(() => {
    var name = customersInLine[0];
    customersInLine.RemoveAt(0);
    return name;
});
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `@autoclosure` 讓函式呼叫看起來非常自然 (像傳值)，但行為卻是傳參考 (邏輯)。
*   **行為面**：常見於 `assert` 函式。例如 `assert(condition, message)`，`message` 部分只有在 `condition` 失敗時才需要運算 (可能包含字串串接等昂貴操作)。使用 `@autoclosure` 可以避免不必要的運算開銷。