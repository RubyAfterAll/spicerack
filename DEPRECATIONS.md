# Deprecation History

## DEP-2021-01-14
*First version introduced: 0.25.4*  
*Deprecated behavior removed: TODO*  

Deprecates `Technologic#instrument` and `Technologic.instrument` in favor of severity-level convenience methods (`info`, `error` etc).

### Remediation
Replace calls of the form:
```ruby
instrument(:info, :an_event_occurred, with: :data)
```

with

```ruby
info(:an_event_occurred, with: :data)
```
