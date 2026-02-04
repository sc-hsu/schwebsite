---
draft : true
title : "[從C#到Swift] 02. Basic Operators"
date : 2026-01-23
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description : "From C# to Swift - 02. Basic Operators"
keywords : ["Swift vs C#", "iOS Development", "Range Operators", "Nil-Coalescing"]
featureImage : "cover.jpg"
featureImageDescription : "From C# to Swift"
slug : "from-csharp-to-swift/basic-operators"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Basic Operators](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/basicoperators)


## 術語與基礎 (Terminology)

### 1. 核心觀念
* **概念解說**：Swift 的運算子分為一元 (Unary)、二元 (Binary) 和三元 (Ternary)。這些概念與大多數 C 語言家族的成員相同。運算子操作的對象稱為運算元 (Operands)。
* **關鍵語法**：`Unary` (-a), `Binary` (a + b), `Ternary` (a ? b : c)
* **官方提示**：無

### 2. 範例解析
**文件原始碼**：
```swift
let i = 1 + 2
if enteredDoorCode && passedRetinaScan { ... }
```
**邏輯解說**：
`+` 是二元運算子，將 1 與 2 相加。`&&` 是邏輯 AND 運算子，用於結合兩個布林值。

### 3. C# 開發者視角
**概念對應**：C# 中同樣擁有這三類運算子，基礎分類完全一致。

**C# 對照程式碼**：
```csharp
int i = 1 + 2;
if (enteredDoorCode && passedRetinaScan) { ... }
```

**關鍵差異分析**：
*   **語法面**：基本一致。
*   **行為面**：無顯著差異。

---

## 賦值運算子 (Assignment Operator)

### 1. 核心觀念
* **概念解說**：使用 `=` 將右邊的值初始化或更新給左邊的變數。Swift 的賦值運算子有一個重要的安全特性：它**不會回傳值**。
* **關鍵語法**：`=`
* **官方提示**：
> 如果賦值運算子的右側是擁有多個值的 Tuple，它的元素可以被一次分解為多個常數或變數。

### 2. 範例解析
**文件原始碼**：
```swift
let b = 10
var a = 5
a = b
// a 現在等於 10

var (x, y) = (1, 2)
// x 等於 1, y 等於 2

if x = y {
    // 這是無效的，因為 x = y 不會回傳值
}
```
**邏輯解說**：
這段程式碼展示了基本的賦值以及 Tuple 的解構賦值。最重要的是最後一段，Swift 編譯器會報錯，防止開發者原本想寫 `==` (比較) 卻誤寫成 `=` (賦值) 的常見錯誤。

### 3. C# 開發者視角
**概念對應**：對應 C# 的 `=` 賦值。但 C# 的賦值表達式是有回傳值的（回傳被賦予的那個值）。

**C# 對照程式碼**：
```csharp
int b = 10;
int a = 5;
a = b;

// C# 7.0+ 支援 Tuple 解構
(int x, int y) = (1, 2);

// C# 中這在某些情況下是合法的（雖然編譯器可能會警告，或者用於 while 迴圈中）
// if (x = y) { ... } // 如果 x, y 是 bool 則編譯通過
```

**關鍵差異分析**：
*   **語法面**：Tuple 解構語法 `let (x, y) = (1, 2)` 非常簡潔，類似 C# 的 `(var x, var y) = (1, 2)`。
*   **行為面**：**陷阱注意**！在 C# 中，`a = b` 表達式的結果是 `b` 的值，這允許連續賦值 `a = b = c`。但在 Swift 中，賦值不回傳值，因此 `a = b = c` 在 Swift 是不合法的，且 `if x = y` 會直接導致編譯錯誤，這是一個防止 Bug 的設計。

---

## 算術運算子 (Arithmetic Operators)

### 1. 核心觀念
* **概念解說**：Swift 支援標準的四則運算 (`+`, `-`, `*`, `/`)。與 C/C++ 不同的是，Swift 預設**不允許值溢位 (Overflow)**，如果計算結果超出型別範圍，程式會報錯（Crash），而非默默截斷。
* **關鍵語法**：`+`, `-`, `*`, `/`, `String concatenation`
* **官方提示**：
> 與 C 和 Objective-C 的算術運算子不同，Swift 的算術運算子預設不允許值溢位。你可以透過 Swift 的溢位運算子（如 `&+`）來啟用溢位行為。

### 2. 範例解析
**文件原始碼**：
```swift
1 + 2       // 等於 3
5 - 3       // 等於 2
2 * 3       // 等於 6
10.0 / 2.5  // 等於 4.0
"hello, " + "world"  // 等於 "hello, world"
```
**邏輯解說**：
展示了整數與浮點數的基本運算，以及 `+` 號可用於字串串接。

### 3. C# 開發者視角
**概念對應**：對應 C# 的算術運算子。

**C# 對照程式碼**：
```csharp
int sum = 1 + 2;
double div = 10.0 / 2.5;
string str = "hello, " + "world";
```

**關鍵差異分析**：
*   **語法面**：完全一致。
*   **行為面**：**記憶體管理與安全**。C# 的 `int` 運算預設在 `unchecked` 環境下會發生溢位（Wrap around），除非你顯式放在 `checked` 區塊中。Swift 則是預設就等同於 `checked`，溢位會導致 Runtime Error。若要像 C# 預設那樣允許溢位，Swift 需改用 `&+`, `&-`, `&*` 等溢位運算子。

---

## 餘數運算子 (Remainder Operator)

### 1. 核心觀念
* **概念解說**：計算 `a % b`，算出多少個 `b` 能塞進 `a`，並回傳剩下的部分。
* **關鍵語法**：`%`
* **官方提示**：
> 餘數運算子 (%) 在其他語言中也被稱為模數運算子 (modulo operator)。然而，嚴格來說，Swift 對負數的行為是「餘數」而非「模數」。

### 2. 範例解析
**文件原始碼**：
```swift
9 % 4    // 等於 1
-9 % 4   // 等於 -1
```
**邏輯解說**：
`9 = (4 x 2) + 1`，故餘數為 1。
`-9 = (4 x -2) + (-1)`，故餘數為 -1。
Swift 的規則是 `a % b` 的正負號取決於 `a`。

### 3. C# 開發者視角
**概念對應**：C# 的 `%` 運算子也是 Remainder Operator，而非數學上的 Modulo。

**C# 對照程式碼**：
```csharp
int r1 = 9 % 4;   // 1
int r2 = -9 % 4;  // -1
```

**關鍵差異分析**：
*   **行為面**：Swift 與 C# 在這點上行為一致，對於負數的處理都是回傳餘數（結果的正負號跟隨被除數）。

---

## 一元運算子 (Unary Minus / Plus Operator)

### 1. 核心觀念
* **概念解說**：`-` 用於切換數值的正負號；`+` 僅回傳數值本身（通常為了對稱性而存在）。
* **關鍵語法**：`-`, `+`

### 2. 範例解析
**文件原始碼**：
```swift
let three = 3
let minusThree = -three       // -3
let plusThree = -minusThree   // 3
let minusSix = -6
let alsoMinusSix = +minusSix  // -6
```
**邏輯解說**：
直接操作數值的正負符號。

### 3. C# 開發者視角
**概念對應**：完全對應 C# 的一元運算子。

**C# 對照程式碼**：
```csharp
int three = 3;
int minusThree = -three;
```

**關鍵差異分析**：
*   **行為面**：無差異。

---

## 複合賦值運算子 (Compound Assignment Operators)

### 1. 核心觀念
* **概念解說**：將運算與賦值結合，如 `+=`。
* **關鍵語法**：`+=`, `-=`, `*=`, `/=`
* **官方提示**：
> 複合賦值運算子不回傳值。例如，你不能寫 `let b = a += 2`。

### 2. 範例解析
**文件原始碼**：
```swift
var a = 1
a += 2
// a 現在是 3
```
**邏輯解說**：
`a += 2` 等同於 `a = a + 2`。

### 3. C# 開發者視角
**概念對應**：C# 也有 `+=`。

**C# 對照程式碼**：
```csharp
int a = 1;
a += 2;
// int b = (a += 2); // 在 C# 這是合法的！
```

**關鍵差異分析**：
*   **行為面**：再次強調，Swift 的 `+=` **沒有回傳值**，而 C# 的 `+=` 會回傳運算後的結果。所以在 Swift 不能像 C# 那樣把它當作表達式的一部分來使用。

---

## 比較運算子 (Comparison Operators)

### 1. 核心觀念
* **概念解說**：用於比較兩個值，回傳 `Bool` (`true` 或 `false`)。Swift 支援 Tuple 的比較（最多由小於 7 個元素組成的 Tuple）。
* **關鍵語法**：`==`, `!=`, `>`, `<`, `>=`, `<=`, `===`, `!==`
* **官方提示**：
> Swift 還提供了兩個恆等運算子（`===` 和 `!==`），用於測試兩個物件參考是否指向同一個物件實例。
> Swift 標準函式庫包含少於 7 個元素的 Tuple 比較運算子。

### 2. 範例解析
**文件原始碼**：
```swift
1 == 1   // true
(1, "zebra") < (2, "apple")   // true (因為 1 < 2)
(3, "apple") < (3, "bird")    // true (3 等於 3，且 apple 小於 bird)
```
**邏輯解說**：
Tuple 的比較是「由左至右」逐一比較。一旦發現某個元素不相等，該元素的比較結果就決定了整個 Tuple 的比較結果。

### 3. C# 開發者視角
**概念對應**：C# 的比較運算子。`===` 對應 C# 的 `Object.ReferenceEquals`。

**C# 對照程式碼**：
```csharp
bool result = 1 == 1;
// C# 7.3+ 支援 Tuple `==` 和 `!=`，但 `<` `>` 並不直接支援 Tuple 比較
var t1 = (1, "zebra");
var t2 = (2, "apple");
// bool tupleComp = t1 < t2; // 編譯錯誤，C# Tuple 不直接支援 <
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `===` 用於 Reference Type 的指標比較，語法比 C# 的 `Object.ReferenceEquals(a, b)` 更簡潔。
*   **行為面**：Swift 原生支援 Tuple 的大小比較 (`<`, `>`)，C# 的 Tuple (`ValueTuple`) 目前僅支援 `==` 與 `!=`，若要比較大小需呼叫 `CompareTo` 或自行撰寫比較邏輯。

---

## 三元條件運算子 (Ternary Conditional Operator)

### 1. 核心觀念
* **概念解說**：`question ? answer1 : answer2`。若 `question` 為真回傳 `answer1`，否則回傳 `answer2`。
* **關鍵語法**：`? :`

### 2. 範例解析
**文件原始碼**：
```swift
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)
// rowHeight 等於 90
```
**邏輯解說**：
這是一種簡潔的 `if-else` 表達式，適合用於單行賦值。

### 3. C# 開發者視角
**概念對應**：完全對應 C# 的 `? :` 運算子。

**C# 對照程式碼**：
```csharp
int contentHeight = 40;
bool hasHeader = true;
int rowHeight = contentHeight + (hasHeader ? 50 : 20);
```

**關鍵差異分析**：
*   **行為面**：無差異。

---

## 空值合併運算子 (Nil-Coalescing Operator)

### 1. 核心觀念
* **概念解說**：`a ?? b`。如果 Optional `a` 有值就解包使用，若是 `nil` 則使用預設值 `b`。
* **關鍵語法**：`??`
* **官方提示**：
> 如果 `a` 的值非 nil，則不會評估 `b` 的值。這稱為短路求值 (short-circuit evaluation)。

### 2. 範例解析
**文件原始碼**：
```swift
let defaultColorName = "red"
var userDefinedColorName: String?   // 預設為 nil
var colorNameToUse = userDefinedColorName ?? defaultColorName
// colorNameToUse 被設為 "red"
```
**邏輯解說**：
這是處理 Optional 非常優雅的方式，避免了冗長的 `if let` 或三元運算子。

### 3. C# 開發者視角
**概念對應**：對應 C# 的 Null-coalescing operator `??`。

**C# 對照程式碼**：
```csharp
string defaultColor = "red";
string? userColor = null;
string colorToUse = userColor ?? defaultColor;
```

**關鍵差異分析**：
*   **語法面**：完全一致。Swift 針對的是 `Optional` 類型，C# 針對的是 Nullable Reference Types 或 Nullable Value Types。

---

## 區間運算子 (Range Operators)

### 1. 核心觀念
* **概念解說**：Swift 提供特殊的運算子來表達數值範圍。
    *   **閉區間 (Closed Range)** `a...b`：包含 `a` 和 `b`。
    *   **半開區間 (Half-Open Range)** `a..<b`：包含 `a` 但不包含 `b`。
    *   **單邊區間 (One-Sided Ranges)** `a...` 或 `...b`：延伸到盡頭。
* **關鍵語法**：`...`, `..<`

### 2. 範例解析
**文件原始碼**：
```swift
// 閉區間
for index in 1...5 { ... } // 1, 2, 3, 4, 5

// 半開區間
for i in 0..<count { ... } // 0 到 count-1

// 單邊區間 (用於陣列切片)
for name in names[2...] { ... } // 從索引 2 到最後
```
**邏輯解說**：
閉區間常用於皆需處理的迴圈；半開區間特別適合用於 0-based 的陣列索引遍歷。

### 3. C# 開發者視角
**概念對應**：C# 8.0 引入了 Range 語法 `..`。

**C# 對照程式碼**：
```csharp
// C# 的 Range 主要用於索引與切片，較少直接用於 foreach 迴圈 (需配合 Enumerable.Range)
sring[] names = { "A", "B", "C", "D" };

// Swift: names[2...]
var slice = names[2..]; 

// Swift: 1...5 (C# 沒有直接對應的迴圈語法，通常用 for 迴圈)
// foreach (var i in 1..5) // C# 不支援這種寫法
foreach (var i in Enumerable.Range(1, 5)) { ... } 
```

**關鍵差異分析**：
*   **語法面**：
    *   Swift 的閉區間是 `...`，C# 的 Range 是 `..`。
    *   Swift 的半開區間是 `..<`，C# 的 `..` 本質上就是半開區間 (Exclusive end)。
*   **行為面**：Swift 的 Range 是非常核心的型別 (`ClosedRange<T>`, `Range<T>`)，可以直接用於 `for-in` 迴圈、`switch` 模式比對 (`case 1...10:`) 以及陣列切片。C# 的 `Range` (`System.Range`) 目前主要用於陣列/Span 的切片索引，不能直接丟進 `foreach` 跑迴圈。

---

## 邏輯運算子 (Logical Operators)

### 1. 核心觀念
* **概念解說**：結合布林邏輯值。
* **關鍵語法**：`!a` (NOT), `a && b` (AND), `a || b` (OR)
* **官方提示**：
> Swift 邏輯運算子 `&&` 和 `||` 是左相依 (left-associative) 的。

### 2. 範例解析
**文件原始碼**：
```swift
if !allowedEntry { ... }
if enteredDoorCode && passedRetinaScan { ... }
if hasDoorKey || knowsOverridePassword { ... }
```
**邏輯解說**：
支援短路求值（Short-circuit evaluation），即 `&&` 前者為假則不看後者，`||` 前者為真則不看後者。

### 3. C# 開發者視角
**概念對應**：完全對應 C# 的邏輯運算子。

**C# 對照程式碼**：
```csharp
if (!allowedEntry) { ... }
if (enteredDoorCode && passedRetinaScan) { ... }
```

**關鍵差異分析**：
*   **行為面**：無差異。兩者都支援短路求值。值得注意的是 Swift 鼓勵使用括號 `()` 來明確複雜表達式的優先級，這在 C# 中也是好習慣。
