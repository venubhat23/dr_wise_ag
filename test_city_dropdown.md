# Testing City Dropdown Fix for Lead Edit Page

## Problem
When editing a lead at https://dr-wise-ag.onrender.com/admin/leads/173/edit, the saved city value (e.g., "Bangalore") was not being properly loaded and selected in the city dropdown.

## Solution Applied
1. **Updated the city select field** to include the saved city as an initial option if it exists
2. **Improved JavaScript logic** to:
   - Preserve the saved city value even when loading new cities for a state
   - Add the saved city as an option if it's not in the loaded cities list
   - Properly initialize Select2 with the saved value

## Changes Made

### 1. Updated HTML (edit.html.erb line 308-311):
- Changed from empty options to include saved city if present
- Added `data-saved_city` attribute to pass the value to JavaScript
- Set disabled state based on whether state is present

### 2. Updated JavaScript (populateCityDropdown function):
- Gets saved city from data attribute or parameter
- Tracks if saved city is found in loaded cities
- Adds saved city as additional option if not found in list
- Properly sets selected value and triggers Select2 change event

### 3. Updated Initialization Logic:
- Improved state/city initialization on page load
- Handles case where city exists but state doesn't
- Ensures proper Select2 initialization with saved values

## Testing Instructions

1. Go to the leads list page
2. Find a lead with a city value (e.g., Lead #173 with Bangalore)
3. Click Edit on that lead
4. Verify that:
   - The state dropdown shows the saved state (if any)
   - The city dropdown shows the saved city value selected
   - The city dropdown is enabled if state is present
   - Changing the state loads new cities but preserves selection if city exists in new list

## Expected Behavior
- When opening edit page for a lead with city "Bangalore", the city dropdown should:
  1. Display "Bangalore" as the selected value
  2. Be enabled for editing
  3. Retain the value even if state changes (unless user explicitly changes it)

## Browser Console Checks
Check browser console for these log messages:
- "Initializing lead edit form with saved state: [state] and city: [city]"
- "Added saved city as additional option: [city]" (if city not in standard list)
- "Set selected city: [city]"