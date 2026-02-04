---
draft : true
title : "[從C#到Swift] 09. Structures and Classes"
date : 2026-01-29
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description : "深入解析 Swift 中 Struct 與 Class 的異同。本文針對 C# 開發者，詳細比較 Value Type 與 Reference Type 的行為差異，探討記憶體管理、語法特性以及 Swift 標準庫中 Struct 的特殊地位，幫助你快速掌握 Swift 的核心建構模組。"
keywords : ["Swift vs C#", "iOS Development", "Struct vs Class", "Value Types", "Identity Operators"]
featureImage : "cover.jpg"
featureImageDescription : "Swift 結構與類別的比較圖示"
slug : "from-csharp-to-swift/structures-and-classes"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Structures and Classes](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures)


## 結構與類別的比較與定義 (Comparing Structures and Classes)

### 1. 核心觀念
*   **概念解說**：
    在 Swift 中，結構 (`struct`) 與類別 (`class`) 是建構程式碼的通用基石。它們都能定義屬性 (Properties) 來儲存值，也能定義方法 (Methods) 來提供功能。與 Objective-C 或 C++ 不同，Swift 不需要建立分開的介面 (.h) 與實作 (.m) 檔案，只需在單一檔案中定義即可。
    雖然兩者語法相似，但 Class 多了繼承、執行時期型別檢查、解構子 (Deinitializers) 以及參考計數 (Reference Counting) 等功能。然而，Swift 官方建議在不需要繼承或參考語意時，**優先使用 Struct**，除非你需要上述 Class 獨有的特性。
*   **關鍵語法**：`struct`, `class`, `Properties`, `Methods`, `Initializers`
*   **官方提示**：
> 傳統上 Class 的實體被稱為物件 (Object)。但在 Swift 中，Struct 和 Class 的功能非常接近，因此官方文件多使用更通用的術語「實體 (Instance)」。

### 2. 範例解析
**文件原始碼**：
```swift
struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}
```

**邏輯解說**：
這段程式碼定義了一個名為 `Resolution` 的結構，用來描述像素解析度；以及一個名為 `VideoMode` 的類別，用來描述影片模式。Swift 會根據初始值（例如 `0`）自動推斷屬性的型別為 `Int`。`name` 屬性被定義為 `String?` (Optional String)，因此會自動獲得預設值 `nil`。

### 3. C# 開發者視角

**概念對應**：
這在 C# 中對應到 `struct` 和 `class` 的定義。

**C# 對照程式碼**：
```csharp
struct Resolution {
    public int Width;
    public int Height;
    // C# 結構通常建議是 Immutable 的，這裡僅為對照 Swift 語法
}

class VideoMode {
    public Resolution Resolution = new Resolution();
    public bool Interlaced = false;
    public double FrameRate = 0.0;
    public string? Name; // C# 8.0+ Nullable Reference Types
}
```

**關鍵差異分析**：
*   **語法面**：
    *   Swift 變數宣告使用 `var` (可變) 或 `let` (常數)，且不需要 `public` 關鍵字即可在模組內存取（預設為 `internal`）。
    *   Swift 的屬性宣告直接給定初始值即可完成型別推斷，語法比 C# 更簡潔。
*   **行為面**：
    *   Swift 的 Struct 可以實作 Protocol (類似 C# Interface)、擁有方法、Extensions 等，幾乎擁有 Class 的大部分功能，除了繼承。
    *   在 C# 中，Struct 通常用於輕量級資料封裝；在 Swift 中，Struct 是**一等公民**，甚至標準庫中的 `String`, `Array`, `Dictionary` 都是 Struct。

---

## 實體化與屬性存取 (Structure and Class Instances & Accessing Properties)

### 1. 核心觀念
*   **概念解說**：
    定義好型別後，需要建立「實體」來使用。Swift 使用建構子語法來建立實體，最簡單的形式就是在型別名稱後加上空括號 `()`。存取屬性則使用點語法 (`.`)。
*   **關鍵語法**：`Instance`, `Dot Syntax`, `Initializer Syntax`

### 2. 範例解析
**文件原始碼**：
```swift
let someResolution = Resolution()
let someVideoMode = VideoMode()

print("The width of someResolution is \(someResolution.width)")
// Prints "The width of someResolution is 0".

someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")
// Prints "The width of someVideoMode is now 1280".
```

**邏輯解說**：
這裡建立了 `Resolution` 和 `VideoMode` 的實體，並且存取其中的屬性。值得注意的是，即使是深層的屬性（如 `someVideoMode.resolution.width`），也可以直接透過點語法進行讀取與賦值。

### 3. C# 開發者視角

**概念對應**：
這與 C# 的物件建立與屬性存取幾乎一致。

**C# 對照程式碼**：
```csharp
var someResolution = new Resolution();
var someVideoMode = new VideoMode();

Console.WriteLine($"The width of someResolution is {someResolution.Width}");

someVideoMode.Resolution.Width = 1280;
```

**關鍵差異分析**：
*   **語法面**：
    *   Swift 建立實體**不需要** `new` 關鍵字。這是習慣 C# 的開發者最常忘記的地方。
    *   Swift 的字串插值使用 `\(variable)`，而 C# 使用字串插值 `$"{variable}"`。

---

## 結構的成員逐一建構子 (Memberwise Initializers for Structure Types)

### 1. 核心觀念
*   **概念解說**：
    Swift 的 Struct 有一個非常方便的特性：如果沒有自定義建構子，編譯器會自動生成一個「成員逐一建構子 (Memberwise Initializer)」，讓你可以在初始化時直接指定各個屬性的值。Class 則沒有這項功能。
*   **關鍵語法**：`Memberwise Initializer`

### 2. 範例解析
**文件原始碼**：
```swift
let vga = Resolution(width: 640, height: 480)
```

**邏輯解說**：
`Resolution` 是一個 Struct，所以自動獲得了一個包含 `width` 和 `height` 參數的建構子。

### 3. C# 開發者視角

**概念對應**：
C# 的 `struct` 在 C# 10 之前沒有這種自動行為。C# 12 引入了 Primary Constructors，或是使用 `record struct` 可以達到類似效果，但標準的 C# `class` 或 `struct` 通常需要手動撰寫建構子或使用 Object Initializer 語法。

**C# 對照程式碼**：
```csharp
// C# Object Initializer syntax
var vga = new Resolution { Width = 640, Height = 480 };

// 或者若有定義建構子
// var vga = new Resolution(640, 480);
```

**關鍵差異分析**：
*   **語法面**：Swift 的成員初始化器是函數參數形式 `(width: 640)`，而 C# 的物件初始化器是大括號屬性賦值 `{ Width = 640 }`。
*   **行為面**：Swift 的自動生成建構子是強制的參數傳遞（除非屬性有預設值），而 C# 的 Object Initializer (`{ }`) 只是在物件建立後設定屬性，語意上略有不同。Swift 的 Class 不會自動獲得這種建構子，必須手動定義 `init`。

---

## 結構與列舉是數值型別 (Structures and Enumerations Are Value Types)

### 1. 核心觀念
*   **概念解說**：
    **Value Type (數值型別)** 的特性是當它被指派給變數、常數，或傳遞給函式時，內容會被**複製 (Copied)**。在 Swift 中，所有的 `struct` 和 `enum` 都是 Value Type。這包含了 Swift 標準庫中的 `Int`, `Double`, `Bool`, `String`, `Array`, `Dictionary`。
*   **關鍵語法**：`Value Type`, `Copy`
*   **官方提示**：
> Swift 標準庫中的集合（如 Array, Dictionary, String）使用了 Copy-on-Write 優化技術。只有在真正修改資料時，才會執行實際的記憶體複製，否則僅是共享記憶體，確保效能。

### 2. 範例解析
**文件原始碼**：
```swift
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048

print("cinema is now \(cinema.width) pixels wide")
// Prints "cinema is now 2048 pixels wide".

print("hd is still \(hd.width) pixels wide")
// Prints "hd is still 1920 pixels wide".
```

**邏輯解說**：
當 `hd` 賦值給 `cinema` 時，發生了複製。因此，修改 `cinema` 的 `width` 完全不會影響到原始的 `hd`。它們是記憶體中兩個獨立的實體。

### 3. C# 開發者視角

**概念對應**：
C# 的 `struct` 也是 Value Type，行為與此相同。

**關鍵差異分析**：
*   **行為面 (極重要)**：
    *   **String 的差異**：C# 的 `string` 是 **Reference Type** (雖然有 Immutable 特性讓它像 Value Type)，但在 Swift 中 `String` 是 **Struct (Value Type)**。這意味著 Swift 的字串傳遞是複製行為（邏輯上），這對 C# 開發者來說是一個巨大的觀念轉變。
    *   **Collection 的差異**：C# 的 `List<T>` 或 `Dictionary<TKey, TValue>` 是 **Class (Reference Type)**。如果你將一個 List 賦值給另一個變數，修改其中一個會影響另一個。但在 Swift 中，`Array` 和 `Dictionary` 是 **Struct**，賦值會產生複製，修改互不影響。這是 C# 開發者轉 Swift 最容易踩雷的地方。

---

## 類別是參考型別 (Classes Are Reference Types)

### 1. 核心觀念
*   **概念解說**：
    **Reference Type (參考型別)** 在賦值或傳遞時**不會**複製，而是傳遞記憶體位址的參考 (Reference)。多個變數可能同時指向同一個實體。Swift 的 `class` 是 Reference Type。
*   **關鍵語法**：`Reference Type`, `Shared Instance`

### 2. 範例解析
**文件原始碼**：
```swift
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
// Prints "The frameRate property of tenEighty is now 30.0".
```

**邏輯解說**：
`tenEighty` 和 `alsoTenEighty` 指向同一個 `VideoMode` 實體。因此，透過 `alsoTenEighty` 修改 `frameRate`，`tenEighty` 看到的數值也會跟著改變。

### 3. C# 開發者視角

**概念對應**：
這完全對應 C# 的 `class` 行為。

**關鍵差異分析**：
*   **語法面**：
    *   注意範例中 `let tenEighty = VideoMode()` 使用了 `let` (常數)。在 Swift 中，這表示 `tenEighty` 這個**指標**不能改變（不能指向別的物件），但它**指向的物件內容**是可以改變的。這與 C# 的 `readonly` 欄位存取 Reference Type 的行為類似。
    *   如果 `VideoMode` 是 Struct，則宣告為 `let` 會導致無法修改其任何屬性（因為 Struct 是將內容視為整體值）。

---

## 識別運算子 (Identity Operators)

### 1. 核心觀念
*   **概念解說**：
    因為 Class 是參考型別，有時候我們需要知道兩個變數是否「指向同一個記憶體實體」。Swift 提供了 `===` (Identical to) 和 `!==` (Not identical to) 來進行判斷。
*   **關鍵語法**：`===`, `!==`

### 2. 範例解析
**文件原始碼**：
```swift
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
```

**邏輯解說**：
這裡使用 `===` 來檢查兩個變數是否參考到同一個 `VideoMode` 實體。注意這與 `==` (Equal to) 不同，`==` 通常是用來比較「值」是否相等（需要實作 `Equatable` protocol）。

### 3. C# 開發者視角

**概念對應**：
這相當於 C# 中的 `Object.ReferenceEquals(a, b)` 或是在未覆寫 `==` 運算子時的預設 Reference 比較。

**C# 對照程式碼**：
```csharp
if (Object.ReferenceEquals(tenEighty, alsoTenEighty)) {
    // ...
}
// 或者對於一般 class
if (tenEighty == alsoTenEighty) { }
```

**關鍵差異分析**：
*   **語法面**：Swift 強制區分「參考相等 (`===`)」與「數值相等 (`==`)」。C# 的 `==` 對於 Reference Type 預設是比較參考，但對於 `string` 或重載過運算子的型別則是比較值，容易混淆。Swift 的設計更加明確。

---