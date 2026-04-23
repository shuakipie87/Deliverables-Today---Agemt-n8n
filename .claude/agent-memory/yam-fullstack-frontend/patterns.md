# Code Patterns - Meat Shop Client

## Zustand Store Pattern
```ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware'; // only if needed

interface XxxState { /* state fields */ }
interface XxxActions { /* action methods */ }
type XxxStore = XxxState & XxxActions;

export const useXxxStore = create<XxxStore>()(
  persist( // wrap with persist() if localStorage needed
    (set, get) => ({ /* ... */ }),
    { name: 'storage-key', partialize: (state) => ({ /* fields to persist */ }) },
  ),
);
```

## Axios Instance
- Base URL: `/api`
- Request interceptor attaches `Bearer` token from `localStorage.getItem('auth-token')`
- Response interceptor handles 401 with token refresh queue pattern
- Normalized `ApiError` on failure

## Utility Functions
- `cn(...classes)` - clsx + tailwind-merge
- `formatPrice(dollars)` - Intl.NumberFormat USD
- `formatWeight(grams)` - Shows g below 1000, kg at/above
- `calculateItemTotal(pricePerKg, weightGrams, quantity)` - line item math
- `generateId()` - timestamp + random for client IDs
- `debounce(fn, delay)` - standard debounce
- `truncate(text, maxLength)` - with ellipsis

## React Query Default Config
- staleTime: 5 min
- gcTime: 10 min
- retry: 1 for queries, 0 for mutations
- refetchOnWindowFocus: false
