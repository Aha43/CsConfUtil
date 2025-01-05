WIP: Do not use!

# **SharpConfig**

SharpConfig is a lightweight utility library for extending the functionality of `IConfiguration` in .NET applications. It simplifies retrieving configuration sections as strongly typed objects, with support for required sections and default naming conventions.

## **Features**

* Retrieve configuration sections as strongly typed objects.  
* Specify custom section names or use default naming based on the type.  
* Exception handling for missing required configuration sections.

## **Installation**

Add the package to your project using the .NET CLI:

`dotnet add package Microsoft.Extensions.Configuration`

## **Usage**

### **Basic Usage**

1. Add a configuration source to your `IConfiguration` instance.  
2. Use the extension methods `GetAs<T>` or `GetRequiredAs<T>` to retrieve configuration sections.

### **Examples**

#### **Example Configuration**

Assume the following JSON configuration:

{  
  "MyClass": {  
    "Property": "Value"  
  },  
  "AnotherClass": {  
    "Property": "AnotherValue"  
  }  
}

#### **Setting Up Configuration**

using Microsoft.Extensions.Configuration;

var configurationBuilder \= new ConfigurationBuilder();  
configurationBuilder.AddJsonFile("appsettings.json");  
var configuration \= configurationBuilder.Build();

#### **Strongly Typed Access**

public class MyClass  
{  
    public string Property { get; set; } \= string.Empty;  
}

// Retrieve configuration section as a strongly typed object  
var myClass \= configuration.GetAs\<MyClass\>();  
if (myClass \!= null)  
{  
    Console.WriteLine(myClass.Property); // Output: Value  
}

#### **Handling Required Sections**

try  
{  
    var requiredClass \= configuration.GetRequiredAs\<MyClass\>();  
    Console.WriteLine(requiredClass.Property); // Output: Value  
}  
catch (ArgumentException ex)  
{  
    Console.WriteLine(ex.Message);  
}

### **Custom Section Names**

By default, `GetAs<T>` and `GetRequiredAs<T>` use the type name as the section name. You can specify a custom name if needed:

var anotherClass \= configuration.GetAs\<MyClass\>("AnotherClass");  
if (anotherClass \!= null)  
{  
    Console.WriteLine(anotherClass.Property); // Output: AnotherValue  
}

## **Unit Testing**

SharpConfig works seamlessly with in-memory configuration for testing:

using Microsoft.Extensions.Configuration;  
using Xunit;

public class ConfigurationExtensionsTests  
{  
    \[Fact\]  
    public void GetAs\_ShouldReturnInstance\_WhenSectionExists()  
    {  
        var configurationBuilder \= new ConfigurationBuilder();  
        configurationBuilder.AddInMemoryCollection(new\[\]  
        {  
            new KeyValuePair\<string, string\>("MyClass:Property", "Value")  
        });

        var configuration \= configurationBuilder.Build();

        var result \= configuration.GetAs\<MyClass\>();  
        Assert.NotNull(result);  
        Assert.Equal("Value", result.Property);  
    }  
}

## **Contributing**

Contributions are welcome\! Feel free to open issues or submit pull requests on GitHub.

## **License**

This project is licensed under the MIT License. See the LICENSE file for details.
