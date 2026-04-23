---
name: ai-proxy generate-colors payload format
description: The generate-colors action in supabase/functions/ai-proxy/index.ts expects a parts array in Gemini format, not separate base64/mime fields
type: project
---

The `generate-colors` action in the `ai-proxy` Edge Function uses a simplified payload format.

**Payload shape from client:**
```typescript
{
  parts: Array<{ inlineData: { data: string; mimeType: string } }>,
  prompt: string,
  responseSchema: any
}
```

**Implementation rules:**
1. Use `payload.parts` directly as the Gemini parts array (already in inlineData format)
2. Append `{ text: payload.prompt }` as the final part
3. Call `generateContent` with those parts and `payload.responseSchema`
4. The `responseSchema` uses string type values (`"OBJECT"`, `"STRING"`, `"BOOLEAN"`) -- NOT `Type.OBJECT` enum values. The Gemini SDK accepts these string equivalents as-is, so no conversion needed.

**Why:** The client pre-builds the Gemini parts array to keep the Edge Function handler simple and avoid duplicating image processing logic on the server side.

**How to apply:** When implementing `supabase/functions/ai-proxy/index.ts`, do NOT expect separate `logoBase64`, `logoMimeType`, `screenshotBase64`, `screenshotMimeType` fields. Use the `parts` array directly.
