# Copilot Instructions for HomeVZ

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
HomeVZ is a comprehensive housing solution platform for Kenya that addresses:
- Rental housing management and accessibility
- Real estate (land sales and leasing)
- Financial services integration (M-Pesa, loans)
- Property verification and tenant-landlord matching

## Architecture Guidelines
- Follow **Clean Architecture** principles with clear separation of concerns
- Use **Feature-First** folder structure
- Implement **Repository Pattern** for data layer
- Use **Riverpod** for state management
- Follow **SOLID principles**

## Code Style and Conventions
- Use **camelCase** for variables and methods
- Use **PascalCase** for classes and constructors
- Prefer **composition over inheritance**
- Write **self-documenting code** with clear variable names
- Add **comprehensive documentation** for public APIs

## UI/UX Guidelines
- Design for **Kenyan market context** (M-Pesa, local languages)
- Ensure **accessibility** for low-end Android devices
- Implement **offline-first** capabilities where possible
- Use **Material Design 3** with custom Kenyan-inspired theming
- Support both **English and Swahili** languages

## Performance Considerations
- Optimize for **low-bandwidth environments**
- Implement **lazy loading** for property images
- Use **efficient state management** to minimize rebuilds
- Consider **local caching** strategies for offline functionality

## Security Best Practices
- Implement **secure authentication** and authorization
- Use **encrypted storage** for sensitive data
- Validate all **user inputs** and API responses
- Follow **OWASP mobile security** guidelines

## Testing Strategy
- Write **unit tests** for business logic
- Implement **widget tests** for UI components
- Create **integration tests** for critical user flows
- Mock **external dependencies** in tests

## Local Context Features
- **M-Pesa integration** for payments
- **ID verification** using Kenyan national ID
- **Local area knowledge** and mapping
- **Multi-language support** (English/Swahili)
- **Local currency** (KES) formatting and calculations
