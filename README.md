# **SharpConfig**

SharpConfig is a lightweight utility library for extending the functionality of `IConfiguration` in .NET applications. It simplifies retrieving configuration sections as strongly typed objects, with support for required sections and default naming conventions.

## **Features**

* Retrieve configuration sections as strongly typed objects.  
* Specify custom section names or use default naming based on the type.  
* Exception handling for missing required configuration sections.

## **Installation**

Add the package to your project using the .NET CLI:

`dotnet add package SharpConfig`

## **Usage**

### **Basic Usage**

1. Add a configuration source to your `IConfiguration` instance.  
2. Use the extension methods `GetAs<T>` or `GetRequiredAs<T>` to retrieve configuration sections.

### **Examples**

#### **Example Configuration**

Assume the following JSON configuration:
```json
{  
  "MyClass": {  
    "Property": "Value"  
  },  
  "AnotherClass": {  
    "Property": "AnotherValue"  
  }  
}
```

#### **Setting Up Configuration**

```csharp
using Microsoft.Extensions.Configuration;
using SharpConfig;

var configurationBuilder = new ConfigurationBuilder();  
configurationBuilder.AddJsonFile("appsettings.json");  
var configuration = configurationBuilder.Build();
```

#### **Strongly Typed Access**

```csharp
public class MyClass  
{  
    public string Property { get; set; } = string.Empty;  
}

// Retrieve configuration section as a strongly typed object  
var myClass = configuration.GetAs<MyClass>();  
if (myClass != null)  
{  
    Console.WriteLine(myClass.Property); // Output: Value  
}
```

#### **Handling Required Sections**

```csharp
try  
{  
    var requiredClass = configuration.GetRequiredAs<MyClass>();  
    Console.WriteLine(requiredClass.Property); // Output: Value  
}  
catch (ArgumentException ex)  
{  
    Console.WriteLine(ex.Message);  
}
```

### **Custom Section Names**

By default, `GetAs<T>` and `GetRequiredAs<T>` use the type name as the section name. You can specify a custom name if needed:

```csharp
var anotherClass = configuration.GetAs<MyClass>("AnotherClass");  
if (anotherClass != null)  
{  
    Console.WriteLine(anotherClass.Property); // Output: AnotherValue  
}
```

## **Contributing**

Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.

## **License**

This project is licensed under the MIT License. See the LICENSE file for details.
