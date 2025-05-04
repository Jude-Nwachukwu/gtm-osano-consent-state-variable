# Osano Consent State – GTM Custom Variable Template (Unofficial)

This Google Tag Manager (GTM) custom variable template lets you retrieve user consent states from the [Osano Consent Management Platform (CMP)](https://www.osano.com/). It's especially useful when:

- Osano is installed **outside GTM** (i.e., directly in the page source).
- You are working with **Basic or Advanced Consent Mode**.
- You want to create **exception triggers** based on specific consent categories.

> Developed by **Jude** for [DumbData](https://dumbdata.co/)

---

## 🛠️ How to Use This Template


## 📦 Import the Template

1. Open Google Tag Manager.
2. Go to **Templates** → **Variable Templates**.
3. Click the **New** button and select **Import**.
4. Upload the `.tpl` file for this template.


## 🎛️ Configuration Options

### 1. **Select Consent State Check Type**

Use the dropdown labeled **“Select Consent State Check Type”** to choose how the variable should behave:

- **All Consent State Check** – Returns an object with all consent categories and their statuses.
- **Specific Consent State** – Returns only the selected category’s consent status.

### 2. **Select Consent Category**

(Only shown when **Specific Consent State** is selected)

Use the radio field **“Select Consent Category”** to target one of the following categories:

- Analytics  
- Essential  
- Marketing  
- Opt Out  
- Personalization  
- Storage  

### 3. **Enable Optional Output Transformation**

Use the checkbox **“Enable Optional Output Transformation”** to convert consent values into more GTM-friendly formats.

#### Sub-options (shown when the above is enabled):

- **Transform "Accept"**: Choose between:
  - `granted`
  - `true`

- **Transform "Deny"**: Choose between:
  - `denied`
  - `false`

- **Also transform "undefined" to "denied"**: Useful for fallback handling when Osano hasn’t initialized a category yet.

## 🎯 Use Cases

- Enabling or blocking tags using Consent Mode signals (`granted`/`denied`)
- Creating GTM exceptions based on individual consent categories
- Interfacing with Osano when it’s **not managed via GTM**, but still needs to integrate with GTM tags

---

> 📦 This template enhances flexibility and compliance in your consent-aware tagging setup, particularly when bridging GTM with a standalone Osano CMP implementation.

