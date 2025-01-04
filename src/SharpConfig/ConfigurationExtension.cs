using Microsoft.Extensions.Configuration;

namespace SharpConfig;

public static class ConfigurationExtensions
{
    public static T? GetAs<T>(this IConfiguration configuration, string? name = default) where T : class
    {
        name ??= typeof(T).Name;
        var section = configuration.GetSection(name);
        return section?.Get<T>();
    }

    public static T GetRequiredAs<T>(this IConfiguration configuration, string? name = default) where T : class
    {
        name ??= typeof(T).Name;
        var retVal = configuration.GetAs<T>(name) ??
            throw new ArgumentException($"Configuration section '{name ?? typeof(T).Name}' of type '{typeof(T)}' not found.");
        return retVal;
    }
}
