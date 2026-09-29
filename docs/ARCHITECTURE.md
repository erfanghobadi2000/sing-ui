# Sing-UI architecture

Sing-UI deliberately separates **presentation** from the **Sing-Box control plane**.

## Source of truth

The S-UI upstream source remains authoritative for:

- authentication and sessions
- database schema
- inbound/client/outbound models
- Sing-Box configuration generation
- subscription generation
- traffic accounting
- Sing-Box process lifecycle
- API endpoints

The 3X-UI repository is used only as a design reference. Xray is not introduced into the runtime.

## Frontend strategy

The first integration layer is intentionally implemented as a patch set over the official S-UI frontend. This keeps protocol support and API compatibility with S-UI instead of pretending that an Xray API can operate a Sing-Box backend.

The theme layer changes:

- application shell
- navigation hierarchy
- desktop rail/sidebar behavior
- top bar
- cards, fields and buttons
- responsive behavior
- light/dark visual tokens

Protocol-specific forms remain S-UI's Sing-Box forms.

## Why not copy the 3X-UI frontend verbatim?

The current 3X-UI frontend is tightly coupled to endpoints and data models such as `/panel/api/inbounds/*`, Xray-oriented models, and Xray lifecycle operations. S-UI exposes a different API and Sing-Box configuration model. A literal copy would produce a visually similar panel that fails when an action is submitted.

For that reason, Sing-UI ports visual patterns while keeping S-UI's functional data layer.

## Future porting work

The next layer can progressively port individual 3X-UI screens while adding a Sing-Box adapter per screen. Each port must pass the build and integration tests before replacing the S-UI implementation.
