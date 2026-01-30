---
title : "[從C#到Swift] 11. Methods"
date : 2026-01-30T18:00:00+08:00
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description: " Swift 的方法 (Methods) 機制。對於 C# 開發者而言，Swift 的 Struct 與 Enum 也能定義方法是一大亮點。本文將重點比較 `mutating` 關鍵字在值型別中的行為，以及 `static` 與 `class` 方法在繼承上的差異，助您無縫轉換物件導向觀念。"
keywords: ["Swift vs C#", "iOS Development", "Mutating Methods", "Type Methods"]
featureImage: "cover.jpg"
featureImageDescription: "Swift 與 C# 方法定義的語法對照圖"
slug : "from-csharp-to-swift/methods"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Methods](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/methods)


## 實體方法 (Instance Methods)

### 1. 核心觀念
*   **概念解說**：實體方法是屬於特定型別（類別、結構、列舉）實例的函數。它們封裝了操作該實例的邏輯。與 Objective-C 僅允許類別定義方法不同，Swift 的 **Struct (結構)** 與 **Enum (列舉)** 也可以擁有方法，這讓 Swift 的值型別 (Value Types) 功能非常強大。
*   **關鍵語法**：`func`, `Class`, `Structure`, `Enumeration`

### 2. 範例解析
**文件原始碼**：
```swift
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}

let counter = Counter()
counter.increment()
counter.increment(by: 5)
counter.reset()
```

**邏輯解說**：
這段程式碼定義了一個 `Counter` 類別，包含三個實體方法。
1.  `increment()`：不帶參數，直接存取並修改內部的 `count` 屬性。
2.  `increment(by:)`：展示了 Swift 的參數標籤 (`argument label`) 特性，呼叫時可讀性更高。
3.  呼叫方式使用點語法 (`.`)，與大多數物件導向語言一致。

### 3. C# 開發者視角

**概念對應**：這與 C# 中的 Instance Method 完全對應。

**C# 對照程式碼**：
```csharp
public class Counter {
    public int Count { get; private set; } = 0;
    
    public void Increment() {
        Count += 1;
    }
    
    public void Increment(int amount) {
        Count += amount;
    }
    
    public void Reset() {
        Count = 0;
    }
}
```

**關鍵差異分析**：
*   **語法面**：Swift 使用 `func` 關鍵字，而 C# 使用回傳型別（如 `void`）作為開頭。Swift 的參數命名支援「外部標籤」與「內部名稱」分離（如 `increment(by amount: Int)`），這讓呼叫端程式碼 `counter.increment(by: 5)` 讀起來像自然語言句型，這是 C# `Named Arguments` 無法完全達到的流暢度。
*   **行為面**：基本行為一致。但在 Swift 中，結構 (Struct) 與列舉 (Enum) 定義方法的頻率比 C# 高出許多，因為 Swift 的 Struct 功能遠比 C# 的 Struct 豐富。

---

## self 屬性 (The self Property)

### 1. 核心觀念
*   **概念解說**：每個實體都有一個隱含的屬性叫做 `self`，代表實體本身。通常不需要顯式寫出 `self`，除非發生名稱衝突（例如參數名稱與屬性名稱相同時），才需要用 `self` 來區分。
*   **關鍵語法**：`self`

### 2. 範例解析
**文件原始碼**：
```swift
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}
```

**邏輯解說**：
在 `isToTheRightOf` 方法中，參數名稱是 `x`，屬性名稱也是 `x`。為了消除歧義 (Disambiguate)，Swift 使用 `self.x` 來指代實體的屬性，而單獨的 `x` 則指代參數。

### 3. C# 開發者視角

**概念對應**：相當於 C# 中的 `this` 關鍵字。

**C# 對照程式碼**：
```csharp
struct Point {
    public double X;
    public double Y;
    
    public bool IsToTheRightOf(double x) {
        // C# 使用 this 來消除歧義
        return this.X > x;
    }
}
```

**關鍵差異分析**：
*   **語法面**：除了關鍵字拼寫不同 (`self` vs `this`)，用法完全一致。
*   **行為面**：無顯著差異。Swift 官方建議非必要不寫 `self`，這與 C# 社群通常建議非必要不寫 `this` 的習慣類似。

---

## 在實體方法中修改數值型別 (Modifying Value Types from Within Instance Methods)

### 1. 核心觀念
*   **概念解說**：Swift 的結構 (Structure) 和列舉 (Enumeration) 是 **值型別 (Value Types)**。在非 mutating 的實體方法中，不能修改 self 或其屬性。如果需要修改，必須在方法宣告前加上 `mutating` 關鍵字。
*   **關鍵語法**：`mutating`
*   **官方提示**：
> 注意：你不能在常數 (Constant, let) 的結構實體上呼叫 `mutating` 方法，因為常數結構的屬性完全不可變更。

### 2. 範例解析
**文件原始碼**：
```swift
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var somePoint = Point(x: 1.0, y: 1.0)
somePoint.moveBy(x: 2.0, y: 3.0)
// Point is now at (3.0, 4.0)

let fixedPoint = Point(x: 3.0, y: 3.0)
// fixedPoint.moveBy(x: 2.0, y: 3.0) // 這行會報錯
```

**邏輯解說**：
`moveBy` 方法會修改 `x` 和 `y`。因為 `Point` 是 Struct，所以必須標記為 `mutating`。當方法結束時，這些改變會寫回原始結構中。

### 3. C# 開發者視角

**概念對應**：C# 的 Struct 預設是可變的 (Mutable)，除非宣告為 `readonly struct`。C# 沒有 `mutating` 這種針對單一方法的標記。

**C# 對照程式碼**：
```csharp
struct Point {
    public double X;
    public double Y;

    // C# 的 struct 方法預設就可以修改欄位 (雖不建議 Mutable Struct)
    public void MoveBy(double deltaX, double deltaY) {
        X += deltaX;
        Y += deltaY;
    }
}
```

**關鍵差異分析**：
*   **語法面**：Swift 強制要求顯式宣告 `mutating`，這是一種「意圖宣告」，讓閱讀者清楚知道這個方法會改變值狀態。C# 則沒有這個關鍵字。
*   **行為面**：
    *   **安全性**：Swift 的設計更安全。如果你宣告 `let p = Point(...)`，編譯器會禁止呼叫任何 `mutating` 方法。
    *   **C# 陷阱**：在 C# 中，如果將 Struct 存放在 `readonly` 欄位中，呼叫會修改狀態的方法可能會導致編譯器建立「防禦性副本 (Defensive Copy)」，修改的是副本而非原值，造成難以察覺的 Bug。Swift 透過明確的 `mutating` 和 `let/var` 機制，在編譯階段就排除了這類問題。

---

## 在 Mutating 方法中指派給 self (Assigning to self Within a Mutating Method)

### 1. 核心觀念
*   **概念解說**：在 `mutating` 方法中，你不僅可以修改屬性，甚至可以直接將一個全新的實體指派給隱含的 `self` 屬性。這在列舉 (Enum) 的狀態切換邏輯中特別好用。
*   **關鍵語法**：`self = ...`

### 2. 範例解析
**文件原始碼**：
```swift
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
```

**邏輯解說**：
這是一個「三段開關」的列舉。`next()` 方法透過檢查當前的 `self` 狀態，直接將 `self` 替換為下一個狀態 (`.low`, `.high` 等)。這是實作有限狀態機 (FSM) 的極簡寫法。

### 3. C# 開發者視角

**概念對應**：C# 的 Struct 允許 `this = new Struct(...)`，但在 Enum 中無法定義方法，更無法修改 `this`。

**C# 對照程式碼**：
```csharp
// C# 的 Enum 只是整數別名，不能包含方法或修改自己
// 必須透過 Extension Method 來模擬，但無法修改原本的變數 (因為是值傳遞)
public enum TriStateSwitch { Off, Low, High }

public static class SwitchExtensions {
    public static TriStateSwitch Next(this TriStateSwitch s) {
        return s switch {
            TriStateSwitch.Off => TriStateSwitch.Low,
            TriStateSwitch.Low => TriStateSwitch.High,
            TriStateSwitch.High => TriStateSwitch.Off,
            _ => TriStateSwitch.Off
        };
    }
}

// 呼叫端必須重新賦值
// mySwitch = mySwitch.Next();
```

**關鍵差異分析**：
*   **語法面**：Swift 的 Enum 是「一等公民」，可以擁有狀態與行為。C# 的 Enum 僅是數值常數。
*   **行為面**：Swift 允許 Enum 透過 `mutating` 方法自我變更，這使得狀態管理的邏輯可以完全封裝在型別內部，呼叫端只需 `switch.next()`。C# 開發者通常需要依賴擴充方法 (Extension Methods) 並回傳新值，或將邏輯移至外部類別處理。

---

## 型別方法 (Type Methods)

### 1. 核心觀念
*   **概念解說**：屬於型別本身而非單一實體的方法，稱為型別方法。
    *   對於 Struct 和 Enum，使用 `static` 關鍵字。
    *   對於 Class，可以使用 `static` (不可被子類別覆寫) 或 `class` (允許被子類別覆寫)。
*   **關鍵語法**：`static func`, `class func`
*   **官方提示**：
> Objective-C 只能在類別定義型別方法。Swift 則允許 Class, Struct, Enum 都能定義。

### 2. 範例解析
**文件原始碼**：
```swift
class SomeClass {
    class func someTypeMethod() {
        // 這裡實作型別方法
    }
}
SomeClass.someTypeMethod()

struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1

    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }

    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    // ... (省略部分實體方法)
}
```

**邏輯解說**：
`LevelTracker` 使用 `static` 定義了 `unlock` 和 `isUnlocked` 方法，這些方法管理著全域的遊戲進度（最高解鎖關卡），而不依賴於特定的玩家實體。

### 3. C# 開發者視角

**概念對應**：相當於 C# 的 `static` 方法。

**C# 對照程式碼**：
```csharp
class SomeClass {
    // C# 的 static 方法不能被 override (除非在介面中使用 static abstract - C# 11+)
    public static void SomeTypeMethod() { }
}

struct LevelTracker {
    public static int HighestUnlockedLevel = 1;
    
    public static void Unlock(int level) {
        if (level > HighestUnlockedLevel) HighestUnlockedLevel = level;
    }
}
```

**關鍵差異分析**：
*   **語法面**：
    *   **`static` vs `class`**：這是 C# 開發者最需要注意的點。
        *   Swift 的 `static func` 在 Class 中等同於 C# 的 `static` (Final，不可覆寫)。
        *   Swift 的 `class func` 在 Class 中相當於 C# 沒有直接對應的概念（可以想像成「可繼承的靜態方法」），允許子類別 `override class func` 提供自己的實作。
*   **行為面**：
    *   **Self 的指代**：在 Swift 的型別方法中，`self` 指的是「型別本身」(The Type)，而不是實體。這與 C# 在靜態方法中不能使用 `this` 不同，Swift 的 `self` 在這裡讓你可以存取其他的靜態屬性或方法，語法統一性更高。
