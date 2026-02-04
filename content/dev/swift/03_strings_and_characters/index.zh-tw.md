---
draft : true
title: "[從C#到Swift] 03. Strings and Characters"
date: 2026-01-24
tags: ["Swift", "C#"]
categories: ["From C# to Swift"]
description: "Swift 的字串與字元處理機制。從 C# 開發者的角度出發，探討 Swift 字串作為 Value Type 的特性、獨特的 Unicode 擴展字形集（Extended Grapheme Clusters）處理方式，以及與 C# 截然不同的索引（Index）操作邏輯。"
keywords: ["Swift vs C#", "iOS Development", "String Interpolation", "Swift Substring"]
featureImage: "cover.png"
featureImageDescription: "From C# to Swift"
slug: "from-csharp-to-swift/strings-and-characters"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Strings and Characters](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/stringsandcharacters)


## 字串字面量與初始化 (String Literals & Initialization)

### 1. 核心觀念
*   **概念解說**：Swift 的 `String` 類型是一個快速且兼容 Unicode 的文字處理工具。它的語法設計輕量，類似 C 語言，但底層實作非常現代化。與 Objective-C 的 `NSString` 不同，Swift 的 `String` 是一個 **struct（Value Type）**，而非 class。
*   **關鍵語法**：`""` (雙引號), `"""` (多行字串), `String()` (初始化), `isEmpty`
*   **官方提示**：
> Swift 的 `String` 類型與 Foundation 的 `NSString` 類別是橋接的 (Bridged)。如果你導入了 `Foundation`，你可以在 `String` 上直接呼叫 `NSString` 的方法而無需轉型。

### 2. 範例解析
**文件原始碼**：
```swift
let someString = "Some string literal value"

// 多行字串 (Multiline String Literals)
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""

// 初始化空字串
var emptyString = ""               // 空字串字面量
var anotherEmptyString = String()  // 初始化語法
if emptyString.isEmpty {
    print("Nothing to see here")
}
```

**邏輯解說**：
Swift 使用雙引號定義單行字串。多行字串則使用三個雙引號 `"""` 包裹，且起始與結束的引號必須獨立成行。縮排規則由結束的 `"""` 位置決定，這讓程式碼排版更加整潔。`isEmpty` 屬性是用來檢查字串是否為空的高效方式。

### 3. C# 開發者視角

**概念對應**：C# 的 `string` 也使用雙引號。Swift 的多行字串類似 C# 11 引入的 Raw String Literals (`"""..."""`) 或較舊的 Verbatim String (`@"..."`)。

**C# 對照程式碼**：
```csharp
// C#
string someString = "Some string literal value";

// C# 11 Raw String Literal (類似 Swift 的多行處理)
string quotation = """
    The White Rabbit put on his spectacles.
    "Begin at the beginning," the King said.
    """;

// 空字串檢查
string emptyString = "";
bool isEmpty = string.IsNullOrEmpty(emptyString); // 或 emptyString.Length == 0
```

**關鍵差異分析**：
*   **語法面**：Swift 的多行字串縮排處理非常智慧，它會自動忽略各行前方與結尾 `"""` 對齊的空白，這在 C# 中直到最近的版本（C# 11）才透過 Raw String Literals 完美支援。
*   **行為面**：Swift 推薦使用 `isEmpty` 屬性，而 C# 開發者習慣用 `string.IsNullOrEmpty()` 或檢查 `Length == 0`。

---

## 字串的可變性與數值型別 (Mutability & Value Types)

### 1. 核心觀念
*   **概念解說**：這是 Swift 與許多語言最大的不同點之一。Swift 的 `String` 是 **Value Type (實值型別)**，而非 Reference Type。此外，字串是否可變（Mutable）完全取決於它是被宣告為變數 (`var`) 還是常數 (`let`)。
*   **關鍵語法**：`var` (可變), `let` (不可變), `struct` (Value Type)

### 2. 範例解析
**文件原始碼**：
```swift
var variableString = "Horse"
variableString += " and carriage"
// variableString 現在是 "Horse and carriage"

let constantString = "Highlander"
// constantString += " and another Highlander"
// 編譯錯誤：常數字串無法被修改
```

**邏輯解說**：
當 `String` 被傳遞給函式或賦值給另一個變數時，實際上會發生**複製**（Copy）。雖然 Swift 編譯器會進行 copy-on-write 優化（即只有在真正修改內容時才複製），但在語意上，你擁有該字串的獨立副本。

### 3. C# 開發者視角

**概念對應**：C# 的 `string` 是 **Reference Type**，但它是不可變的 (Immutable)。若要修改字串，C# 通常會產生新的物件或使用 `StringBuilder`。

**C# 對照程式碼**：
```csharp
// C#
string str = "Horse";
str += " and carriage"; // 實際上創造了一個新的 string 物件並重新指向

// C# 沒有直接對應 let 的常數宣告來禁止重新賦值引發的修改，
// 除非使用 const (需編譯時確認) 或 readonly (僅限欄位)。
```

**關鍵差異分析**：
*   **語法面**：Swift 用 `var` 直接支援字串修改（拼接），類似於 C# 的 `StringBuilder` 的易用版，但語法上像普通字串操作。
*   **行為面**：**這是最大陷阱**。在 C# 中，字串變數存的是參考（Reference）；在 Swift 中，`String` 是 Struct。
    *   **C#**: `string a = "hi"; string b = a;` -> a 和 b 指向堆積區同一塊記憶體。
    *   **Swift**: `var a = "hi"; var b = a; b += "!"` -> 修改 b **不會** 影響 a，因為賦值發生時產生了拷貝（邏輯上）。

---

## 字串擴充與插值 (Concatenation & Interpolation)

### 1. 核心觀念
*   **概念解說**：Swift 提供了直觀的運算子來串接字串，以及強大的字串插值功能，允許在字串中嵌入變數或運算式。
*   **關鍵語法**：`+`, `+=`, `append()`, `\(expression)`

### 2. 範例解析
**文件原始碼**：
```swift
let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2

var instruction = "look over"
instruction += string2

// 字串插值
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message 為 "3 times 2.5 is 7.5"
```

**邏輯解說**：
字串插值使用反斜線加括號 `\(...)` 的語法。這比起傳統的格式化字串更直觀且強型別安全。

### 3. C# 開發者視角

**概念對應**：相當於 C# 的字串串接與 String Interpolation。

**C# 對照程式碼**：
```csharp
// C#
int multiplier = 3;
// C# 使用 $ 字號和大括號
string message = $"{multiplier} times 2.5 is {multiplier * 2.5}";
```

**關鍵差異分析**：
*   **語法面**：Swift 使用 `\()`，C# 使用 `{}` (配合 `$`)。
*   **行為面**：兩者在編譯時都會轉化為高效的字串建構呼叫。注意 Swift 的插值括號內不能包含未轉義的反斜線或換行符號。

---

## Unicode 與字元計數 (Unicode, Characters & Counting)

### 1. 核心觀念
*   **概念解說**：Swift 的 `String` 是基於 **Unicode Scalar Values** 建構的。最特別的是它對 **Extended Grapheme Clusters (擴展字形集)** 的支援。一個「人類可讀的字元」（如 `é` 或 🇹🇼）可能由一個或多個 Unicode 純量組成，但在 Swift 中它們都被視為單一個 `Character`。
*   **關鍵語法**：`Character`, `count` 屬性, `\u{n}`

### 2. 範例解析
**文件原始碼**：
```swift
let eAcute: Character = "\u{E9}"                         // é
let combinedEAcute: Character = "\u{65}\u{301}"          // e 後面接撇號
// 兩者在 Swift 中都被視為同一個字元

var word = "cafe"
word += "\u{301}" // 加上撇號
print("the number of characters in \(word) is \(word.count)")
// 輸出 "the number of characters in café is 4" (雖然加了東西，但視覺上還是一個字，長度不變)
```

**邏輯解說**：
這是 Swift 字串處理最強大也最複雜的地方。`count` 屬性回傳的是「人類看起來有幾個字」，而不是底層用了幾個 Byte 或幾個 16-bit 單位。因為需要計算字形集邊界，存取 `count` 可能需要遍歷整個字串，並非 O(1) 操作。

### 3. C# 開發者視角

**概念對應**：C# 的 `char` 是 16-bit (UTF-16 code unit)。C# 的 `string.Length` 回傳的是 16-bit 單位的數量，而非真實字元數。

**C# 對照程式碼**：
```csharp
// C#
string word = "cafe";
word += "\u0301"; // 加上結合重音符
Console.WriteLine(word.Length); 
// 輸出 5 (因為 e 和 重音符 是兩個分開的 char)
```

**關鍵差異分析**：
*   **語法面**：無特別差異，但 Swift 的 Unicode 轉義是用 `\u{...}` 可容納不同長度 Hex，C# 是 `\uXXXX` 或 `\UXXXXXXXX`。
*   **行為面**：**極度重要！**
    *   **Emoji 處理**：一個 Emoji (如 🐶) 在 C# `string.Length` 通常是 2 (Surrogate Pair)；在 Swift `.count` 是 1。
    *   **效能**：C# 的 `Length` 是 O(1)；Swift 的 `count` 需遍歷字串，是 O(n)。若在迴圈中頻繁呼叫 `count` 需注意效能。

---

## 存取與修改字串 (Accessing and Modifying)

### 1. 核心觀念
*   **概念解說**：由於上述的 Unicode 複雜性（每個字元長度不等），Swift **不允許** 使用整數索引（例如 `str[0]`）來存取字串。你必須使用 `String.Index`。
*   **關鍵語法**：`startIndex`, `endIndex`, `index(before:)`, `index(after:)`, `index(_:offsetBy:)`

### 2. 範例解析
**文件原始碼**：
```swift
let greeting = "Guten Tag!"
// 存取第一個字元
greeting[greeting.startIndex] // G

// 存取特定位置 (例如第 7 個字元)
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index] // a

// 插入
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex)

// 移除
welcome.remove(at: welcome.index(before: welcome.endIndex))
```

**邏輯解說**：
你不能直接寫 `greeting[7]`，必須先計算出代表「第 7 個字形集」的 `String.Index` 物件，再用它來取值。這是為了防止隨機存取切斷了多位元組的字元（如切斷 Emoji 的一半）。

### 3. C# 開發者視角

**概念對應**：C# 允許整數索引 `str[i]`，但這存取的是 `char` (UTF-16 code unit)，不一定是完整字元。

**C# 對照程式碼**：
```csharp
// C#
string greeting = "Guten Tag!";
char c = greeting[7]; // 直接使用整數索引 'a'

// 插入與移除 (C# string 不可變，需產生新字串)
string welcome = "hello";
welcome = welcome.Insert(welcome.Length, "!");
welcome = welcome.Remove(welcome.Length - 1);
```

**關鍵差異分析**：
*   **語法面**：Swift 的索引語法非常冗長（`index(_:offsetBy:)`）。這是為了強迫開發者意識到字串遍歷的成本。
*   **行為面**：在 C# 中你習慣 `for (int i=0; i<str.Length; i++)`，但在 Swift 中應盡量使用 `for char in string` 或高階函數。如果你需要頻繁隨機存取，建議將 `String` 轉為 `Array` (`Array(str)`)，但要注意這會失去部分 Unicode 處理特性且增加記憶體消耗。

---

## 子字串 (Substrings)

### 1. 核心觀念
*   **概念解說**：當你對 Swift 字串進行切片（Slicing）時，回傳的型別不是 `String`，而是 `Substring`。`Substring` 會與原始字串共用記憶體，這是一種效能優化。
*   **關鍵語法**：`prefix(_:)`, `[range]`, `Substring` 型別, `String(substring)`

### 2. 範例解析
**文件原始碼**：
```swift
let greeting = "Hello, world!"
let index = greeting.firstIndex(of: ",") ?? greeting.endIndex
let beginning = greeting[..<index]
// beginning 的型別是 Substring，它重用了 greeting 的記憶體

// 若要長期儲存，需轉回 String
let newString = String(beginning)
```

**邏輯解說**：
`Substring` 雖然高效，但不適合長期持有。因為只要 `Substring` 還在，原始的完整 `String` 記憶體就無法被釋放。

### 3. C# 開發者視角

**概念對應**：C# 的 `Substring()` 方法傳統上會分配新的記憶體並複製字串。但在較新的 C# (Core/Standard) 中，`Span<char>` 或 `ReadOnlySpan<char>` 的概念與 Swift 的 `Substring` 非常相似——它們都是原本記憶體的「視圖 (View)」。

**C# 對照程式碼**：
```csharp
// C# (傳統)
string greeting = "Hello, world!";
int idx = greeting.IndexOf(',');
string beginning = greeting.Substring(0, idx); // 分配新記憶體

// C# (高效能 Span)
ReadOnlySpan<char> span = greeting.AsSpan();
ReadOnlySpan<char> slice = span.Slice(0, idx); // 零配置，類似 Swift Substring
```

**關鍵差異分析**：
*   **行為面**：Swift 強制區分 `String` 和 `Substring` 型別，防止你無意間長期持有大字串的引用。C# 的 `Substring` 直接回傳 `string` (發生複製)，除非你顯式使用 `Span`。

---

## 字串比較 (Comparing Strings)

### 1. 核心觀念
*   **概念解說**：Swift 的字串比較是用「標準等價 (Canonical Equivalence)」進行的。這意味著如果兩個字串顯示出來一樣，它們就相等，即使底層的 Unicode 組成不同。
*   **關鍵語法**：`==`, `!=`, `hasPrefix()`, `hasSuffix()`

### 2. 範例解析
**文件原始碼**：
```swift
// "é" (單一純量) vs "e" + "́" (組合純量)
let eAcuteQuestion = "Voulez-vous un caf\u{E9}?"
let combinedEAcuteQuestion = "Voulez-vous un caf\u{65}\u{301}?"

if eAcuteQuestion == combinedEAcuteQuestion {
    print("These two strings are considered equal")
}
```

**官方提示**：
> Swift 的字串與字元比較不是 Locale-sensitive（與語系環境無關）的。

### 3. C# 開發者視角

**概念對應**：C# 的 `==` 是基於 UTF-16 code unit 的內容比較（ordinal），不做 Unicode 正規化。

**C# 對照程式碼**：
```csharp
// C#
string s1 = "\u00E9";
string s2 = "e\u0301";
Console.WriteLine(s1 == s2); // False! 因為底層 char 序列不同

// 若要達到 Swift 的效果，需正規化
Console.WriteLine(s1.Normalize() == s2.Normalize()); // True
```

**關鍵差異分析**：
*   **行為面**：這是另一個潛在 Bug 來源。Swift 的 `==` 比較聰明（但也比較慢），會自動處理 Unicode 正規化。C# 的 `==` 比較快，但嚴格比較 `char` 序列。若需在 C# 做類似比較，需手動呼叫 `String.Normalize()`。
