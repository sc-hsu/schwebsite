---
title : "[從C#到Swift] 01. The Basics"
date : 2026-01-22
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description : "From C# to Swift - 01. The Basics"
keywords : ["Swift vs C#", "iOS Development"]
featureImage : "cover.png"
featureImageDescription : "From C# to Swift"
slug : "from-csharp-to-swift/thebasics"
---

![](cover.png)


> **從 C# 視角學習 Swift : [The Basic](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics)**


## 常數與變數 (Constants and Variables)

### 1. 核心觀念
* **概念解說**：Swift 非常強調安全性，因此在宣告儲存容器時，強制區分「不可變 (Immutable)」與「可變 (Mutable)」。這有助於編譯器優化並防止意外修改數據。
* **關鍵語法**：`let` (常數), `var` (變數)
* **官方提示**：
> 如果你的代碼中儲存的值不會改變，請務必使用 `let` 關鍵字宣告為常數。只有在需要改變值時才使用變數。

### 2. 範例解析
**文件原始碼**：
```swift
let maximumNumberOfLoginAttempts = 10
var currentLoginAttempt = 0

var environment = "development"
let maximumNumberOfLoginAttempts: Int
// maximumNumberOfLoginAttempts 目前還沒有值

if environment == "development" {
    maximumNumberOfLoginAttempts = 100
} else {
    maximumNumberOfLoginAttempts = 10
}
// 現在 maximumNumberOfLoginAttempts 有值了，可以被讀取
```

**邏輯解說**：
這段代碼展示了 `let` 與 `var` 的基本宣告。值得注意的是，`let` 宣告的常數不一定要在宣告的那一行立即賦值（如第二段範例），但必須保證在第一次讀取前「被賦值一次且僅一次」。

### 3. C# 開發者視角

**概念對應**：
* Swift 的 `var` 對應 C# 的 `var` (或明確型別變數)。
* Swift 的 `let` 概念上介於 C# 的 `const` 與 `readonly` 之間，但在區域變數的使用上，C# 沒有完全等價的「執行期不可變區域變數」關鍵字 (雖然 C# 的 `const` 必須是編譯期常數)。

**C# 對照程式碼**：
```csharp
// C#
const int MaximumNumberOfLoginAttempts = 10; // 必須在編譯期確認數值
var currentLoginAttempt = 0;

// C# 模擬 Swift 的延遲初始化常數 (C# 無法直接對區域變數做唯讀強制檢查)
int maxLoginAttempts; 
var environment = "development";

if (environment == "development") {
    maxLoginAttempts = 100;
} else {
    maxLoginAttempts = 10;
}
// 在 C# 中，maxLoginAttempts 之後仍可被修改，這就是安全性差異
```

**關鍵差異分析**：
* **語法面**：Swift 用 `let` 和 `var` 兩個關鍵字統治所有宣告；C# 則常混用 `var`、`const`、`readonly` 和明確型別。
* **行為面**：Swift 的 `let` 允許「執行期計算 (Runtime evaluation)」，只要保證賦值一次即可。C# 的 `const` 必須是「編譯期常數 (Compile-time constant)」。這讓 Swift 的 `let` 比 C# 的 `const` 更有彈性且常用。

---

## 型別標註與推斷 (Type Safety and Inference)

### 1. 核心觀念
* **概念解說**：Swift 是強型別語言 (Type Safe)。你可以明確告訴編譯器變數是什麼型別 (Type Annotation)，也可以讓編譯器根據初始值自動猜測 (Type Inference)。
* **關鍵語法**：`:` (冒號後接型別), `String`, `Int`, `Double`

### 2. 範例解析
**文件原始碼**：
```swift
var welcomeMessage: String
welcomeMessage = "Hello"

var x = 0.0, y = 0.0, z = 0.0 // 推斷為 Double

let meaningOfLife = 42 // 推斷為 Int
let pi = 3.14159 // 推斷為 Double
```

**邏輯解說**：
當沒有提供初始值時（如 `welcomeMessage`），必須明確寫出 `: String`。若有初始值（如 `meaningOfLife`），編譯器會自動推斷。

### 3. C# 開發者視角

**概念對應**：這與 C# 的型別系統幾乎一致。

**C# 對照程式碼**：
```csharp
// C#
string welcomeMessage;
welcomeMessage = "Hello";

var x = 0.0; // 推斷為 double
var meaningOfLife = 42; // 推斷為 int
```

**關鍵差異分析**：
* **語法面**：Swift 變數名稱在冒號前，型別在冒號後 (`name: Type`)；C# 是型別在前 (`Type name`)。
* **行為面**：兩者的推斷機制 (Swift 的 Type Inference vs C# 的 `var`) 非常相似。但 Swift 對型別轉換更嚴格（完全不允許隱式轉換，詳見後文）。

---

## 數值型別與轉換 (Numeric Types and Conversion)

### 1. 核心觀念
* **概念解說**：Swift 提供了 `Int`、`UInt`、`Double`、`Float` 等數值型別。特別注意 Swift 不支援不同數值型別之間的「隱式轉換 (Implicit Conversion)」，即使是將整數放入浮點數變數也必須顯式轉換。
* **關鍵語法**：`Int.min`, `Int.max`, `Double(...)`, `Int(...)`
* **官方提示**：
> 除非你需要特定大小的整數（如處理外部資料），否則請一律使用 `Int`。即使在 32 位元平台上，`Int` 也足夠涵蓋 -20 億到 20 億的範圍。

### 2. 範例解析
**文件原始碼**：
```swift
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one) // 必須手動轉換

let three = 3
let pointOneFourOneFiveNine = 0.14159
let pi = Double(three) + pointOneFourOneFiveNine // 整數轉浮點
```

**邏輯解說**：
Swift 不允許將 `UInt8` 直接加到 `UInt16` 上，也不允許將 `Int` 與 `Double` 直接相加。必須使用構造函數（如 `UInt16(one)`）進行轉換，這其實是建立了一個新數值。

### 3. C# 開發者視角

**概念對應**：C# 允許「擴大轉換 (Widening Conversions)」的隱式行為，但 Swift 完全禁止。

**C# 對照程式碼**：
```csharp
// C#
ushort twoThousand = 2000;
byte one = 1;
var result = twoThousand + one; // C# 自動隱式轉換，合法

int three = 3;
double pointOne = 0.14159;
var pi = three + pointOne; // C# 自動將 int 轉為 double，合法
```

**關鍵差異分析**：
* **語法面**：Swift 使用建構式語法 `Type(value)` 進行轉換；C# 使用轉型語法 `(Type)value` 或 `Convert.ToType(value)`。
* **行為面**：**這是 C# 開發者最容易遇到的編譯錯誤**。C# 習慣 `int + double` 自動變 `double`，但在 Swift 中這會報錯。Swift 設計哲學認為隱式轉換是 Bug 的溫床。
* **型別細節**：
    * Swift 的 `Int` 取決於平台（64-bit 平台上是 64-bit）。
    * C# 的 `int` 永遠是 32-bit (`Int32`)。C# 9.0 後的 `nint` 才相當於 Swift 的 `Int`。

---

## 元組 (Tuples)

### 1. 核心觀念
* **概念解說**：Tuple 允許將多個值組合成一個複合值。非常適合用於函式回傳多個結果，而不需要為此建立一個新的 Struct 或 Class。
* **關鍵語法**：`(Val1, Val2)`, `.0`, `.1`, `(name: Val)`

### 2. 範例解析
**文件原始碼**：
```swift
let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")

// 使用索引存取
print("The status code is \(http404Error.0)")

// 命名元素
let http200Status = (statusCode: 200, description: "OK")
print("The status code is \(http200Status.statusCode)")
```

**邏輯解說**：
Tuples 可以解構 (Decompose) 成單獨的常數，也可以透過索引 (`.0`) 或標籤名稱 (`.statusCode`) 存取。

### 3. C# 開發者視角

**概念對應**：對應現代 C# (C# 7.0+) 的 `ValueTuple`。

**C# 對照程式碼**：
```csharp
// C#
var http404Error = (404, "Not Found");
var (statusCode, statusMessage) = http404Error; // 解構

// 命名元素
var http200Status = (StatusCode: 200, Description: "OK");
Console.WriteLine(http200Status.StatusCode);
```

**關鍵差異分析**：
* **語法面**：兩者語法驚人地相似。
* **行為面**：Swift 的 Tuple 和 C# 的 ValueTuple 都是 Value Type。但 Swift 官方建議 Tuple 僅用於臨時數據組合（如函式回傳），若資料結構複雜，應轉用 `struct` 或 `class`。

---

## 選項型別 (Optionals)

### 1. 核心觀念
* **概念解說**：這是 Swift **最重要**的特性。Optional 代表「可能有值，也可能完全沒有值 (nil)」。Swift 的普通型別（如 `Int`, `String`）**絕對不能**是 nil。要處理缺失值，必須加上 `?` 變成 Optional。
* **關鍵語法**：`Type?`, `nil`, `if let`, `!`, `??`
* **官方提示**：
> 在 Objective-C 中，nil 指向一個不存在的物件指標；在 Swift 中，nil 不是指標，而是代表「值不存在 (Absence of a value)」的一種狀態。任何型別（包括 Int）都可以是 Optional。

### 2. 範例解析
**文件原始碼**：
```swift
var serverResponseCode: Int? = 404
serverResponseCode = nil // 現在沒有值了

// Optional Binding (安全解包)
if let actualNumber = Int("123") {
    print("Has value: \(actualNumber)")
} else {
    print("Conversion failed")
}

// Implicitly Unwrapped Optionals (隱式解包)
let assumedString: String! = "Always has value"
let implicitString: String = assumedString // 自動解包，不需 !
```

**邏輯解說**：
* `Int("123")` 回傳的是 `Int?`，因為轉換可能失敗。
* `if let` 是 Swift 特有的語法，用於檢查 Optional 是否有值，若有則解包並賦值給臨時常數 `actualNumber`，該常數在 if 區塊內是安全的非 Optional 型別。
* `String!` 用於那些「宣告後保證一直有值」的情況（如 UI 元件初始化後），使用時不用每次都解包，但若為 nil 會導致 Crash。

### 3. C# 開發者視角

**概念對應**：
* 類似 C# 的 `Nullable<T>` (`int?`) 以及 C# 8.0+ 的 Nullable Reference Types (`string?`)。
* 但 Swift 的 Optional 實作上是一個 `Enum` (`Case None`, `Case Some(Wrapped)`).

**C# 對照程式碼**：
```csharp
// C#
int? serverResponseCode = 404;
serverResponseCode = null;

// C# 模式匹配 (類似 Swift 的 if let)
string possibleNumber = "123";
if (int.TryParse(possibleNumber, out int actualNumber)) {
     Console.WriteLine($"Has value: {actualNumber}");
}
// 或者對於 Nullable Types
if (serverResponseCode is int code) {
    // code 在此處為 int，非 int?
}

// C# 沒有 Implicitly Unwrapped Optionals (!) 的直接對應
// 通常用 string! 告訴編譯器 "我知道這不是 null" (Null-forgiving operator)
```

**關鍵差異分析**：
* **語法面**：Swift 的 `if let x = opt` 語法非常簡潔。C# 需要使用 `is` 模式匹配 `if (opt is {} x)` 來達到類似效果。
* **行為面**：
    * C# 的 Reference Types 預設仍可能為 null (除非開啟 nullable context 並忽略警告)，Runtime 仍可能拋出 `NullReferenceException`。
    * Swift 透過編譯器強制檢查，如果不解包 (Unwrap) 就無法使用 Optional 裡面的值，從根本上杜絕了意外的 Null Reference 錯誤。
* **強制解包**：Swift 的 `!` (Force Unwrap) 若遇上 nil 會直接 Crash；類似 C# 的 `.Value` 存取但在空值時拋出異常。

---

## 錯誤處理 (Error Handling)

### 1. 核心觀念
* **概念解說**：Swift 使用 `throws`、`try`、`do-catch` 來處理可預期的錯誤。這與 Optionals 不同，Optionals 處理「值的缺失」，Error Handling 處理「操作失敗的原因」。
* **關鍵語法**：`throws`, `try`, `do { ... } catch { ... }`

### 2. 範例解析
**文件原始碼**：
```swift
func makeASandwich() throws {
    // ... 可能拋出錯誤
}

do {
    try makeASandwich()
    eatASandwich()
} catch SandwichError.outOfCleanDishes {
    washDishes()
} catch SandwichError.missingIngredients(let ingredients) {
    buyGroceries(ingredients)
}
```

**邏輯解說**：
函式宣告 `throws` 表示它可能會失敗。呼叫時必須在前面加 `try`，並包在 `do-catch` 區塊中處理異常。Swift 的錯誤通常是 Enum，可以攜帶關聯值（如 `missingIngredients` 帶出的清單）。

### 3. C# 開發者視角

**概念對應**：對應 C# 的 `try-catch` 機制。

**C# 對照程式碼**：
```csharp
// C#
void MakeASandwich() {
    // ... throw new Exception(...)
}

try {
    MakeASandwich();
    EatASandwich();
} catch (OutOfCleanDishesException) {
    WashDishes();
} catch (MissingIngredientsException ex) {
    BuyGroceries(ex.Ingredients);
}
```

**關鍵差異分析**：
* **語法面**：Swift 要求在呼叫點明確寫出 `try`，這讓開發者一眼就能看出哪行程式碼可能拋出錯誤，C# 則隱式拋出。
* **行為面**：C# 的 Exception 是昂貴的物件（包含 Stack Trace）；Swift 的 Error 通常是輕量級的 Struct 或 Enum，效能開銷極低，因此在 Swift 中用 Error 做流程控制是可以接受的。

---

## 斷言與前置條件 (Assertions and Preconditions)

### 1. 核心觀念
* **概念解說**：用於執行期間檢查邏輯假設。如果條件為 false，程式會終止。這是除錯與確保程式狀態正確的重要工具。
* **關鍵語法**：`assert` (僅 Debug 模式生效), `precondition` (Debug 與 Release 皆生效)

### 2. 範例解析
**文件原始碼**：
```swift
let age = -3
assert(age >= 0, "A person's age can't be less than zero.")
// 在 Debug 模式下會觸發 Crash

// Index 檢查
precondition(index > 0, "Index must be greater than zero.")
```

### 3. C# 開發者視角

**概念對應**：
* Swift `assert` 對應 C# `Debug.Assert`。
* Swift `precondition` 對應 C# `Trace.Assert` 或手動 `if (!cond) throw ...`。

**C# 對照程式碼**：
```csharp
// C#
using System.Diagnostics;

int age = -3;
Debug.Assert(age >= 0, "A person's age can't be less than zero.");
```

**關鍵差異分析**：
* Swift 明確區分了「僅除錯用 (`assert`)」和「生產環境也要檢查 (`precondition`)」的語法，C# 通常依賴 `System.Diagnostics` 命名空間或合約 (Contracts) 來處理。