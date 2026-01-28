---
title : "[從C#到Swift] 08. Enumerations"
date : 2026-01-28
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description : "本文深入解析 Swift 的 Enumerations，這不只是簡單的數值列表，而是擁有強大功能的型別系統。對於 C# 開發者來說，Swift 的 Enum 結合了 Associated Values (類似 Discriminated Unions) 與方法擴充能力，將徹底改變你對枚舉的認知。掌握這些差異能助你寫出更安全、更具表達力的 iOS 程式碼。"
keywords : ["Swift vs C#", "iOS Development", "Swift Enums", "Discriminated Unions"]
featureImage : "cover.png"
featureImageDescription : "Swift 與 C# 枚舉結構對比示意圖"
slug : "from-csharp-to-swift/enumerations"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Enumerations](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/enumerations)


## 基本語法 (Enumeration Syntax)

### 1. 核心觀念
*   **概念解說**：在 Swift 中，`Enumeration` (枚舉) 定義了一組相關值的通用型別。與 C 或 C# 不同，Swift 的 Enum 不僅僅是整數的別名。它們是一等公民 (First-class types)，擁有自己的屬性、方法，甚至可以實作 Protocol。預設情況下，Swift 的 Case **不會** 自動被賦予整數值 (如 0, 1, 2)。
*   **關鍵語法**：`enum`, `case`
*   **官方提示**：
> 這一點與 C 和 Objective-C 不同。在 Swift 中，枚舉成員本身就是完整的數值，其型別是明確定義的枚舉型別名稱，而非預設隱含為整數。

### 2. 範例解析
**文件原始碼**：
```swift
enum CompassPoint {
    case north
    case south
    case east
    case west
}

var directionToHead = CompassPoint.west
directionToHead = .east // 型別已推斷，可省略型別名稱
```

**邏輯解說**：
這裡定義了一個名為 `CompassPoint` 的枚舉。我們定義了四個方位。注意在使用時，一旦變數 `directionToHead` 的型別被推斷為 `CompassPoint`，後續賦值時可以使用簡寫語法 `.east`，這讓程式碼非常簡潔。

### 3. C# 開發者視角

**概念對應**：這相當於 C# 的 `enum`，但底層實作完全不同。

**C# 對照程式碼**：
```csharp
enum CompassPoint {
    North,
    South,
    East,
    West
}
// C# 中使用時必須寫全名 (除非使用 using static)
var direction = CompassPoint.West;
```

**關鍵差異分析**：
*   **語法面**：C# 預設 `North` 等於 `0`。Swift 的 `north` 就是 `north`，它不等於 `0`。
*   **行為面**：Swift 的點語法 (`.east`) 依賴型別推斷，比 C# 更簡潔。在 C# 中，Enum 本質上是數值型別 (Value Type) 的包裝；在 Swift 中，Enum 是一種更抽象的代數資料型別 (Algebraic Data Type)。

---

## 使用 Switch 匹配 (Matching Enumeration Values with a Switch Statement)

### 1. 核心觀念
*   **概念解說**：Swift 使用 `switch` 來匹配枚舉值。最重要的一點是 **Exhaustiveness (窮盡性)**，意即你必須處理每一個可能的 `case`，否則編譯器會報錯。這強迫開發者在新增枚舉成員時，必須檢查所有相關的邏輯。
*   **關鍵語法**：`switch`, `case`, `default`

### 2. 範例解析
**文件原始碼**：
```swift
directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
```

**邏輯解說**：
這段程式碼檢查 `directionToHead` 的值。由於我們列出了所有四個方位，編譯器確認已涵蓋所有情況，因此不需要 `default` 分支。

### 3. C# 開發者視角

**概念對應**：對應 C# 的 `switch` 陳述式或 C# 8.0+ 的 `switch` 表達式。

**C# 對照程式碼**：
```csharp
switch (direction)
{
    case CompassPoint.North:
        Console.WriteLine("...");
        break;
    case CompassPoint.South:
        Console.WriteLine("Watch out for penguins");
        break;
    // C# 編譯器通常不會強制要求你列出所有 enum case，
    // 雖然現代 IDE 會給予警告，但這不是編譯錯誤。
}
```

**關鍵差異分析**：
*   **行為面**：Swift 的強制窮盡性 (Exhaustiveness) 是一個極佳的安全特性。在 C# 中，如果你忘記處理某個新的 Enum 成員，程式可能默默執行過去；在 Swift 中，程式碼會無法編譯，強迫你修正。

---

## 遍歷枚舉 (Iterating over Enumeration Cases)

### 1. 核心觀念
*   **概念解說**：有時候我們需要取得枚舉中所有可能的列表（例如為了製作選單）。Swift 提供了一個標準做法：讓 Enum 遵循 `CaseIterable` 協議。
*   **關鍵語法**：`CaseIterable`, `.allCases`

### 2. 範例解析
**文件原始碼**：
```swift
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")

for beverage in Beverage.allCases {
    print(beverage)
}
```

**邏輯解說**：
加上 `CaseIterable` 後，編譯器會自動生成一個 `allCases` 集合屬性。你可以直接對其進行迴圈操作或計算數量。

### 3. C# 開發者視角

**概念對應**：C# 沒有內建介面來做這件事，通常依賴 Reflection (反射)。

**C# 對照程式碼**：
```csharp
enum Beverage { Coffee, Tea, Juice }

// Modern C# (.NET 5+) 使用泛型方法
foreach (Beverage b in Enum.GetValues<Beverage>())
{
    Console.WriteLine(b);
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `CaseIterable` 是編譯時生成的，更加型別安全且效能更好。C# 的 `Enum.GetValues` 依賴執行時期的反射，開銷較大且語法較冗長。

---

## 關聯值 (Associated Values)

### 1. 核心觀念
*   **概念解說**：這是 Swift Enum 與 C# Enum **最大的分水嶺**。在 Swift 中，Enum 的每一個 case 可以攜帶不同型別的自訂資料。這被稱為「關聯值」。這讓 Enum 變成了 Discriminated Unions (辨識聯集) 或 Tagged Unions。
*   **關鍵語法**：`case name(Type)`
*   **官方提示**：
> 這種行為類似於其他語言中的 discriminated unions、tagged unions 或 variants。

### 2. 範例解析
**文件原始碼**：
```swift
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
```

**邏輯解說**：
`Barcode` 可以是四個整數組成的 `upc`，**或者** 是一個字串組成的 `qrCode`。它不能同時是兩者。在 `switch` 中，我們可以使用 `let` 將這些內部資料解構 (Destructure) 出來使用。

### 3. C# 開發者視角

**概念對應**：標準 C# `enum` **完全無法** 做到這點。在 C# 中要模擬這個模式，通常需要使用抽象類別 (Abstract Class) 配合繼承，或者使用第三方套件如 `OneOf`。

**C# 對照程式碼 (模擬)**：
```csharp
// Modern C# 可以使用 record 來簡化 Discriminated Unions 的模擬
abstract record Barcode;
record Upc(int N1, int N2, int N3, int N4) : Barcode;
record QrCode(string Code) : Barcode;

// 使用時需進行型別檢查 (Pattern Matching)
Barcode bar = new QrCode("ABC");
switch (bar)
{
    case Upc u:
        Console.WriteLine($"UPC: {u.N1}...");
        break;
    case QrCode q:
        Console.WriteLine($"QR: {q.Code}");
        break;
}
```

**關鍵差異分析**：
*   **行為面**：Swift 的 Enum 是 Value Type (值型別)，非常輕量。上述 C# 範例則是用 Class/Record (Reference Type) 模擬，結構較重。
*   **思維轉換**：C# 開發者習慣將 Enum 視為「狀態標記」；Swift 開發者則將 Enum 視為「攜帶資料的狀態容器」。

---

## 原始值 (Raw Values)

### 1. 核心觀念
*   **概念解說**：如果你懷念 C# 風格的 Enum (每個 case 對應一個固定值)，Swift 透過 `Raw Values` 來支援。這些值在定義時就固定了，且必須由相同型別組成 (如全部是 Int 或全部是 String)。
*   **關鍵語法**：`enum Name: Type`, `.rawValue`

### 2. 範例解析
**文件原始碼**：
```swift
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

enum CompassPoint: String {
    case north, south, east, west
}
// CompassPoint.south.rawValue 為 "south" (隱式賦值)
```

**邏輯解說**：
透過在 Enum 名稱後加上 `: Type`，我們定義了原始值的型別。Swift 甚至支援 String 作為原始值，且若不指定，會直接使用 case 的名稱作為字串值，非常方便。

### 3. C# 開發者視角

**概念對應**：這就是標準的 C# `enum` 行為，但支援更多型別。

**C# 對照程式碼**：
```csharp
enum Planet : int { // C# 只能是整數型別 (byte, int, long...)
    Mercury = 1,
    Venus,
    Earth
}
```

**關鍵差異分析**：
*   **語法面**：C# 的 Enum 底層限制為整數。Swift 的 Raw Value 可以是 `String`、`Character`、`Int`、`Float` 等。
*   **行為面**：在 Swift 中，存取底層數值必須明確呼叫 `.rawValue` 屬性，不能像 C# 那樣直接強制轉型 (Cast)。

---

## 從原始值初始化 (Initializing from a Raw Value)

### 1. 核心觀念
*   **概念解說**：當 Enum 有原始值時，你可以用該原始值反向建立 Enum 實例。但因為傳入的值可能無效 (例如傳入 999 但沒有定義對應的 case)，所以這個初始化器是 **Failable (可失敗的)**，回傳的是 Optional (`Enum?`)。
*   **關鍵語法**：`init(rawValue:)`
*   **官方提示**：
> 原始值初始化器是一個 Failable Initializer，因為並非所有的原始值都能找到對應的枚舉成員。

### 2. 範例解析
**文件原始碼**：
```swift
let possiblePlanet = Planet(rawValue: 7)
// possiblePlanet 型別為 Planet?

let positionToFind = 11
if let somePlanet = Planet(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}
```

**邏輯解說**：
使用 `Planet(rawValue: 11)` 嘗試建立實例。因為 11 超出了定義範圍，它回傳 `nil`。這裡使用了 Swift 的 `if let` (Optional Binding) 來安全地處理結果。

### 3. C# 開發者視角

**概念對應**：C# 的強制轉型 `(Enum)intValue`。

**C# 對照程式碼**：
```csharp
int position = 11;
Planet p = (Planet)position; // C# 允許這樣做！p 的值現在是 11，即使沒有定義

if (Enum.IsDefined(typeof(Planet), p)) {
    // 安全檢查
} else {
    Console.WriteLine("Invalid planet");
}
```

**關鍵差異分析**：
*   **行為面**：這是 C# 開發者最容易踩雷的地方。C# 允許你將任意整數轉型為 Enum，即使該數值沒有定義在 Enum 中，這可能導致執行期邏輯錯誤。Swift 的 `init(rawValue:)` 強制回傳 `Optional`，強迫開發者處理「轉換失敗」的情況，安全性高出許多。

---

## 遞迴枚舉 (Recursive Enumerations)

### 1. 核心觀念
*   **概念解說**：當一個 Enum 的 Associated Value (關聯值) 中包含了該 Enum 本身時，這就是遞迴枚舉。這對於描述樹狀結構（如數學表達式）非常有用。由於 Enum 預設會以 inline 方式儲存其關聯值，遞迴定義會導致型別大小無法在編譯期確定，因此需要使用 indirect，讓編譯器改用間接儲存。
*   **關鍵語法**：`indirect case`, `indirect enum`

### 2. 範例解析
**文件原始碼**：
```swift
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
print(evaluate(product)) // Prints "18"
```

**邏輯解說**：
這裡定義了一個數學表達式結構。`(5 + 4) * 2` 被優雅地用 Enum 結構表示出來。`evaluate` 函式透過遞迴呼叫自身來計算結果。

### 3. C# 開發者視角

**概念對應**：C# 的 Enum 不支援此功能。這在 C# 中通常是用 Class 的遞迴結構來實現（即 Composite Pattern）。

**C# 對照程式碼**：
```csharp
abstract class Expression { }
class Number : Expression { public int Value; }
class Addition : Expression { public Expression Left; public Expression Right; }
// ...
```

**關鍵差異分析**：
*   **語法面**：Swift 允許在 Value Type (Enum) 中使用 `indirect` 實現遞迴結構，這在語法上非常簡潔且具備函數式編程的風格。C# 必須使用 Reference Type (Class) 來構建這種資料結構。