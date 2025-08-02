# Testing Authorization Service

This document explains how to test the Authorization Service in the SilkRewards app.

## Quick Test with Script

The fastest way to test the authorization endpoint:

```bash
# Navigate to project root
cd /path/to/SilkRewards-iOS

# Run the test script
swift scripts/test_auth_service.swift 555123456 +1

# With Georgian number
swift scripts/test_auth_service.swift 599123456 +995
```

The script will:
- Detect the current environment (dev/prod)
- Send an authorization request
- Display formatted response with colors
- Show request/response details and timing

## Unit Tests

Run unit tests for the NetworkingKit:

```bash
# Run all NetworkingKit tests
swift test --filter NetworkingKitTests

# Run only authorization tests
swift test --filter AuthorizationServiceTests

# Run with verbose output
swift test --filter AuthorizationServiceTests -v
```

## Integration Tests

To run integration tests against the real API:

```bash
# Set environment variable and run tests
INTEGRATION_TESTS=1 swift test --filter testAuthorizationIntegration
```

## Testing in Xcode

1. Open `SilkRewards.xcodeproj`
2. Select the `NetworkingKit` scheme
3. Press `Cmd+U` to run tests
4. Or use `Cmd+6` to open Test Navigator and run specific tests

## Environment Testing

Test different environments:

```bash
# Test with development environment
ENVIRONMENT_TYPE=ENVIRONMENT_TYPE_DEVELOPMENT swift scripts/test_auth_service.swift 555123456 +1

# Test with production environment  
ENVIRONMENT_TYPE=ENVIRONMENT_TYPE_PRODUCTION swift scripts/test_auth_service.swift 555123456 +1
```

## Expected Responses

### Success Response
```json
{
  "data": null,
  "message": "Authorization code sent successfully",
  "success": true
}
```

### Error Response
```json
{
  "data": null,
  "message": "Invalid phone number",
  "success": false
}
```

## Debugging Tips

1. **Network Issues**: If you get connection errors, check:
   - VPN settings
   - API server availability
   - Network connectivity

2. **Invalid Responses**: Enable verbose logging:
   ```bash
   swift scripts/test_auth_service.swift 555123456 +1 2>&1 | tee test_output.log
   ```

3. **Certificate Issues**: For development server, you may need to allow insecure connections in Info.plist:
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSExceptionDomains</key>
       <dict>
           <key>34.40.98.219</key>
           <dict>
               <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
               <true/>
           </dict>
       </dict>
   </dict>
   ```