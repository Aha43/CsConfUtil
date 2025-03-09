using Microsoft.Extensions.Configuration;

namespace CsConfUtil.IntegrationTest;

public class ConfigurationExtensionsTests
{
    private static IConfiguration BuildConfiguration()
    {
        var configurationBuilder = new ConfigurationBuilder();
        configurationBuilder.AddInMemoryCollection(
        [
            new KeyValuePair<string, string?>("MyClass:Property", "Value"),
            new KeyValuePair<string, string?>("AnotherClass:Property", "AnotherValue")
        ]);

        return configurationBuilder.Build();
    }

    public class MyClass
    {
        public string Property { get; set; } = string.Empty;
    }

    public class AnotherClass
    {
        public string Property { get; set; } = string.Empty;
    }

    [Fact]
    public void GetAs_ShouldReturnInstance_WhenSectionExists()
    {
        // Arrange
        var configuration = BuildConfiguration();

        // Act
        var result = configuration.GetAs<MyClass>();

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Value", result.Property);
    }

    [Fact]
    public void GetAs_ShouldReturnNull_WhenSectionDoesNotExist()
    {
        // Arrange
        var configuration = BuildConfiguration();

        // Act
        var result = configuration.GetAs<NonExistentClass>();

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public void GetRequiredAs_ShouldReturnInstance_WhenSectionExists()
    {
        // Arrange
        var configuration = BuildConfiguration();

        // Act
        var result = configuration.GetRequiredAs<MyClass>();

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Value", result.Property);
    }

    [Fact]
    public void GetRequiredAs_ShouldThrowException_WhenSectionDoesNotExist()
    {
        // Arrange
        var configuration = BuildConfiguration();

        // Act & Assert
        var exception = Assert.Throws<ArgumentException>(() => configuration.GetRequiredAs<NonExistentClass>());
        Assert.Equal("Configuration section 'NonExistentClass' of type 'CsConfUtil.IntegrationTest.ConfigurationExtensionsTests+NonExistentClass' not found.", exception.Message);
    }

    private class NonExistentClass
    {
        public string Property { get; set; } = string.Empty;
    }
}
