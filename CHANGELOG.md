# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-03-09

### Initial Release

- Introduced `CsConfUtil`, a lightweight **.NET utility** for extending `IConfiguration`.
- Added extension methods:
  - `GetAs<T>()` → Retrieves configuration sections as strongly typed objects, defaulting to the class name as the section key.
  - `GetRequiredAs<T>()` → Retrieves required configuration sections, throwing an exception if missing.

### Features

- Supports **automatic mapping** of configuration sections to class types.
- Works with **ASP.NET Core’s `IConfiguration`**.
- Provides **optional custom section names**.
