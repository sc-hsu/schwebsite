---
draft : true
title : "[從C#到Swift] 10. Properties"
date : 2026-01-30T14:00:00+08:00
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description: "Swift 儲存屬性、計算屬性、屬性觀察者 (willSet/didSet) 以及強大的屬性包裝器 (Property Wrappers)。本文專為 C# 開發者撰寫，透過詳細的語法對比與觀念分析，幫助你快速掌握 Swift 屬性的獨特之處與使用陷阱。"
keywords: ["Swift vs C#", "iOS Development", "Properties"]
featureImage: "cover.jpg"
featureImageDescription: "Swift 標誌與屬性語法程式碼片段的示意圖"
slug : "from-csharp-to-swift/properties"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Properties](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties)


## 儲存屬性 (Stored Properties)

### 1. 核心觀念
*   **概念解說**：這是最基本的屬性形式，用於將常數 (constant) 或變數 (variable) 的值儲存在實例 (Instance) 中。這概念與 C# 的欄位 (Fields) 類似，但 Swift 的屬性整合度更高。
*   **關鍵語法**：`var` (變數), `let` (常數)
*   **官方提示**：
> 如果你建立了一個結構 (Structure) 的實例並將其指派給一個常數 (`let`)，你將無法修改該實例的任何屬性，即使這些屬性被宣告為變數 (`var`)。這是因為結構是實值型別 (Value Type)。類別 (Class) 則是參考型別 (Reference Type)，不受此限制。

### 2. 範例解析
**文件原始碼**：
```swift
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
// 範圍表示整數 0, 1, 2
rangeOfThreeItems.firstValue = 6
// 範圍現在表示整數 6, 7, 8

let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// rangeOfFourItems.firstValue = 6 
// 這行會報錯，因為 rangeOfFourItems 是 let (常數)，且 struct 是 Value Type
```

**邏輯解說**：這段程式碼展示了如何在 Struct 中定義可變屬性 (`firstValue`) 與不可變屬性 (`length`)。同時展示了當 Struct 實例本身被宣告為常數時，其內部的變數屬性也會變得不可修改。

### 3. C# 開發者視角

**概念對應**：
*   Swift 的 `Stored Property` 對應 C# 的 **Field (欄位)** 或 **Auto-implemented Property (自動實作屬性)**。
*   Swift 的 `let` 對應 C# 的 `readonly` 關鍵字。

**C# 對照程式碼**：
```csharp
public struct FixedLengthRange {
    public int FirstValue;          // 類似 var
    public readonly int Length;     // 類似 let

    public FixedLengthRange(int first, int len) {
        FirstValue = first;
        Length = len;
    }
}
// C# 的 Struct 行為
var range = new FixedLengthRange(0, 3);
range.FirstValue = 6; // 合法

// 在 C# 若將結構宣告為 readonly 欄位，行為類似 Swift 的 let instance
// private readonly FixedLengthRange rangeConst = new FixedLengthRange(0, 4);
// rangeConst.FirstValue = 6; // 編譯錯誤，C# 也會阻擋修改
```

**關鍵差異分析**：
*   **語法面**：Swift 用 `let` 和 `var` 關鍵字區分非常直觀。C# 則需要使用 `readonly` 修飾符。
*   **行為面**：C# 的 Property (`{ get; set; }`) 背後其實是有方法的，而 Swift 的 Stored Property 更像是直接存取記憶體 (但在語法上統一了)。最大的差異在於 Swift 強制初始化：所有的 Stored Properties 必須在初始化階段 (`init`) 完成賦值，或者提供預設值，否則編譯失敗。C# 則允許欄位保留預設值 (0 或 null)。

---

## 延遲儲存屬性 (Lazy Stored Properties)

### 1. 核心觀念
*   **概念解說**：有些屬性的初始化非常耗時（例如讀取檔案、複雜計算），或者依賴於其他屬性初始化完成後才能決定。這時可以使用 `lazy`，讓該屬性直到「第一次被存取」時才進行初始化。
*   **關鍵語法**：`lazy var`
*   **官方提示**：
> 延遲屬性必須宣告為變數 (`var`)，因為它的值在實例初始化完成後才被檢索。常數屬性 (`let`) 必須在初始化完成前就有值，因此不能宣告為 `lazy`。
> 注意：如果 `lazy` 屬性在未初始化時被多個執行緒同時存取，無法保證它只會被初始化一次 (非 Thread-safe)。

### 2. 範例解析
**文件原始碼**：
```swift
class DataImporter {
    /* 假設這個類別需要花費大量時間來初始化 */
    var filename = "data.txt"
}

class DataManager {
    lazy var importer = DataImporter()
    var data: [String] = []
}

let manager = DataManager()
manager.data.append("Some data")
// 此時 DataImporter 的實例尚未建立
print(manager.importer.filename)
// 直到這行被執行，importer 屬性才被建立
```

**邏輯解說**：`DataManager` 被建立時，`importer` 並不會佔用記憶體或執行初始化。直到程式碼第一次呼叫 `manager.importer`，`DataImporter` 的實例才真正產生。

### 3. C# 開發者視角

**概念對應**：
*   C# 沒有直接的關鍵字對應，最接近的是使用 `Lazy<T>` 類別。

**C# 對照程式碼**：
```csharp
public class DataManager {
    // C# 必須使用泛型類別 Lazy<T>
    private Lazy<DataImporter> _importer = new Lazy<DataImporter>(() => new DataImporter());
    
    // 使用 Expression-bodied member 簡化語法
    public DataImporter Importer => _importer.Value;
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `lazy` 關鍵字是語言層級的支援，寫法極其簡潔。C# 需要宣告 `Lazy<T>` 並透過 `.Value` 存取。
*   **行為面**：C# 的 `Lazy<T>` 預設是 **Thread-safe** 的，而 Swift 的 `lazy` **不是** Thread-safe 的。這是一個巨大的行為陷阱，C# 開發者在使用 Swift `lazy` 處理併發情境時需額外小心。

---

## 計算屬性 (Computed Properties)

### 1. 核心觀念
*   **概念解說**：這種屬性不直接儲存值，而是提供 `getter` 和一個可選的 `setter` 來間接存取或計算其他屬性的值。
*   **關鍵語法**：`get`, `set`, `newValue` (setter 的預設參數名)

### 2. 範例解析
**文件原始碼**：
```swift
struct Point { var x = 0.0, y = 0.0 }
struct Size { var width = 0.0, height = 0.0 }
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            // Shorthand Setter: 這裡可以直接使用 newValue
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}
```

**邏輯解說**：`center` 屬性並不存在於記憶體中，讀取它時會執行 `get` 區塊計算出中心點；設定它時會執行 `set` 區塊反推並修改 `origin` 的座標。Swift 支援簡寫，setter 中若不指定參數名，預設可用 `newValue`；getter 若只有一行程式碼，可省略 `return`。

### 3. C# 開發者視角

**概念對應**：
*   完全對應 C# 的 **Properties** (`get` / `set` 區塊)。

**C# 對照程式碼**：
```csharp
struct Rect {
    public Point Origin;
    public Size Size;

    public Point Center {
        get {
            // C# 也可以表達式主體定義 (Expression-bodied members)
            return new Point(Origin.X + (Size.Width / 2), Origin.Y + (Size.Height / 2));
        }
        set {
            // C# 的 setter 隱含參數名固定為 value
            Origin.X = value.X - (Size.Width / 2);
            Origin.Y = value.Y - (Size.Height / 2);
        }
    }
}
```

**關鍵差異分析**：
*   **語法面**：非常相似。C# 使用 `value` 作為 setter 的隱含參數，Swift 使用 `newValue`（但 Swift 允許你自訂這個名稱，例如 `set(newCenter) { ... }`）。
*   **唯讀屬性**：C# 使用 `{ get; }`，Swift 如果只有 getter，可以直接省略 `get { }` 包裹，直接寫大括號內容。

---

## 屬性觀察者 (Property Observers)

### 1. 核心觀念
*   **概念解說**：讓你監控屬性值的變化。當屬性即將被設定或已經被設定時觸發程式碼。這常用於更新 UI 或連動修改其他變數。
*   **關鍵語法**：`willSet` (設定前), `didSet` (設定後)
*   **官方提示**：
> 父類別屬性的 `willSet` 和 `didSet` 會在子類別初始化器中設定屬性時被呼叫。但在類別自己的初始化器 (`init`) 中設定自己的屬性時，觀察者**不會**被呼叫。

### 2. 範例解析
**文件原始碼**：
```swift
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("將要設定 totalSteps 為 \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("增加了 \(totalSteps - oldValue) 步")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// 輸出: 將要設定 totalSteps 為 200
// 輸出: 增加了 200 步
```

**邏輯解說**：當 `totalSteps` 被賦值時，系統會先執行 `willSet`，此時屬性還是舊值，新值透過參數傳入。賦值完成後執行 `didSet`，此時屬性已是新值，舊值透過 `oldValue` (預設名稱) 存取。

### 3. C# 開發者視角

**概念對應**：
*   C# 沒有直接的語法糖。要達到相同效果，必須將 Auto-implemented Property 展開為帶有 `_backingField` 的完整屬性，並在 setter 中手寫邏輯。

**C# 對照程式碼**：
```csharp
class StepCounter {
    private int _totalSteps = 0;
    public int TotalSteps {
        get { return _totalSteps; }
        set {
            // willSet 邏輯
            Console.WriteLine($"將要設定 totalSteps 為 {value}");
            
            int oldValue = _totalSteps;
            _totalSteps = value;
            
            // didSet 邏輯
            if (_totalSteps > oldValue) {
                Console.WriteLine($"增加了 {_totalSteps - oldValue} 步");
            }
        }
    }
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `willSet`/`didSet` 非常優雅，不需要手動管理 backing field。C# 寫起來顯得繁瑣，這也是為什麼 C# 開發者常依賴 `INotifyPropertyChanged` 或 AOP 框架來處理這類需求。
*   **行為面**：Swift 的觀察者只在屬性被「設定」時觸發，即使新值等於舊值也會觸發。

---

## 屬性包裝器 (Property Wrappers)

### 1. 核心觀念
*   **概念解說**：用於封裝屬性的讀寫邏輯（例如：數值限制、UserDefaults 儲存、Thread-safety 鎖）。透過 `@WrapperName` 語法，可以重複使用這些邏輯。
*   **關鍵語法**：`@propertyWrapper`, `wrappedValue`, `projectedValue` (`$`)

### 2. 範例解析
**文件原始碼**：
```swift
@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
rectangle.height = 24
print(rectangle.height) 
// 輸出 "12"，因為被 wrapper 限制住了
```

**邏輯解說**：`TwelveOrLess` 是一個定義了 `wrappedValue` 的結構。當我們在 `height` 前面加上 `@TwelveOrLess`，編譯器會自動將 `height` 的存取轉發給 `TwelveOrLess` 的 `wrappedValue` getter/setter。這讓驗證邏輯只需寫一次。

**Projected Value ($)**:
Swift 還允許 Wrapper 提供額外資訊 (Projected Value)。
```swift
@propertyWrapper
struct SmallNumber {
    private var number: Int
    private(set) var projectedValue: Bool
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }

    init() {
        self.number = 0
        self.projectedValue = false
    }
}
struct SomeStructure {
    @SmallNumber var someNumber: Int
}
var someStructure = SomeStructure()


someStructure.someNumber = 4
print(someStructure.$someNumber)
// Prints "false".

someStructure.someNumber = 55
print(someStructure.$someNumber)
// Prints "true"

```

### 3. C# 開發者視角

**概念對應**：
*   這在 C# 中**沒有直接對應的語法**。
*   外觀上看起來像 C# 的 **Attributes** (`[Attribute]`)，但行為完全不同。C# 的 Attributes 主要是元數據 (Metadata)，被動地等待反射讀取；而 Swift 的 Property Wrappers 是**主動的**，直接介入屬性的 getter/setter 邏輯。
*   邏輯上這更像是 **AOP (Aspect-Oriented Programming)** 或是 **Decorator Pattern** 的語法糖。

**關鍵差異分析**：
*   **語法面**：`$` 符號 (Projected Value) 是 Swift 獨有的概念，讓開發者可以直接存取 Wrapper 暴露出來的輔助功能（例如 Binding 機制在 SwiftUI 中大量使用 `$State` 來取得 Binding）。

---

## 型別屬性 (Type Properties)

### 1. 核心觀念
*   **概念解說**：屬於「型別」本身而非單一實例的屬性。無論建立了多少實例，型別屬性只有一份。
*   **關鍵語法**：`static` (Struct/Enum/Class), `class` (僅 Class，允許子類別 override)
*   **官方提示**：
> 儲存型別屬性 (Stored Type Properties) 必須要有預設值，因為型別沒有初始化器 (Initializer)。且它們**預設就是 lazy 的** (第一次存取才初始化)，並且保證 **Thread-safe** (只會初始化一次)。

### 2. 範例解析
**文件原始碼**：
```swift
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}

class SomeClass {
    static var storedTypeProperty = "Some value."
    // 使用 class 關鍵字，允許子類別 override 這個計算屬性
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
```

### 3. C# 開發者視角

**概念對應**：
*   對應 C# 的 **static** 成員。

**C# 對照程式碼**：
```csharp
class SomeClass {
    public static string StoredTypeProperty = "Some value.";
    
    // C# 的 static 成員無法被 override，這是與 Swift 最大的差別
    public static int ComputedTypeProperty {
        get { return 1; }
    }
}
```

**關鍵差異分析**：
*   **Override 能力**：在 C# 中，`static` 成員是無法被繼承覆寫 (Override) 的。但在 Swift 中，如果你在 Class 中使用 `class` 關鍵字宣告計算型別屬性，子類別是可以 `override` 它的。這提供了比 C# 更靈活的靜態多型能力。
*   **執行緒安全**：C# 的 `static` 欄位初始化通常依賴靜態建構式 (Static Constructor) 來保證執行順序，但不一定保證存取時的 Thread-safe (需自行 lock)。Swift 官方文件明確保證 `static` stored properties 的初始化是 Thread-safe 的。
