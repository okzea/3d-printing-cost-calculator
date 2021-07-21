---
---

###
# Forked from https://makersylvaindenis.000webhostapp.com/cost_calc.js by makersylvaindenis
###

# ---
# Set variables
# ---

COOKIE_DAYS = 365
floatObjectWeight = ''
floatPrintingTime = ''
floatElectricRate = ''
floatPrinterPower = ''
floatFilamentCost = ''
floatPrinterPurchase = ''
floatPrinterLife = ''
floatPrinterUse = ''
floatRepairRate = ''
floatOtherCosts = ''
floatFailureRate = ''
boolInvestmentMode = ''

# ---
# setCookie - set a cookie on the host device
# ---

setCookie = (strCookieName, intCookieValue, intExpireDays) ->
  dateExDate = undefined
  # Set cookie with value and expiry date
  dateExDate = new Date
  dateExDate.setDate dateExDate.getDate() + intExpireDays
  document.cookie = strCookieName + '=' + escape(intCookieValue) + (if intExpireDays == null then '' else ';expires=' + dateExDate.toGMTString())
  return

# ---
# getCookie - read a cookie from the host device
# ---

getCookie = (strCookieName) ->
  intCookieStart = undefined
  intCookieEnd = undefined
  strCookieValue = undefined
  # Assume no cookie until found
  strCookieValue = ''
  # Extract cookie value if it exists
  if document.cookie.length > 0
    intCookieStart = document.cookie.indexOf(strCookieName + '=')
    if intCookieStart != -1
      intCookieStart = intCookieStart + strCookieName.length + 1
      intCookieEnd = document.cookie.indexOf(';', intCookieStart)
      if intCookieEnd == -1
        intCookieEnd = document.cookie.length
      strCookieValue = unescape(document.cookie.substring(intCookieStart, intCookieEnd))
  # Return cookie value
  strCookieValue

# ---
# calcEnergy - returns electricity costs for object
# ---

calcEnergy = ->
  floatEnergy = undefined
  floatKW = undefined
  floatPoundsHour = undefined
  # Calculations based on spreadsheet
  floatKW = floatPrinterPower / 1000.0
  floatPoundsHour = floatKW * floatElectricRate
  floatEnergy = floatPoundsHour * floatPrintingTime
  # Return energy cost
  floatEnergy

# ---
# calcFilament - returns filament costs for object
# ---

calcFilament = ->
  floatFilament = undefined
  # Calculations based on spreadsheet
  floatFilament = floatFilamentCost / 1000.0 * floatObjectWeight
  # Return floatFilament cost
  floatFilament

# ---
# calcLifetime - returns lifetime hours for object
# ---

calcLifetime = ->
  floatLifetime = undefined
  # Calculations based on spreadsheet
  floatLifetime = 365.0 * floatPrinterLife * floatPrinterUse
  # Return depreciation cost
  floatLifetime

# ---
# calcDepreciation - returns depreciation costs for object
# ---

calcDepreciation = ->
  floatDepreciation = undefined
  floatLifetime = undefined
  floatDeprHr = undefined
  # Calculations based on spreadsheet
  floatLifetime = calcLifetime()
  floatDeprHr = floatPrinterPurchase / floatLifetime
  floatDepreciation = floatDeprHr * floatPrintingTime
  # Return depreciation cost
  floatDepreciation

# ---
# calcRepairs - returns repair costs for object
# ---

calcRepairs = ->
  floatRepairs = undefined
  floatRepairsHr = undefined
  # Calculations based on spreadsheet
  floatRepairsHr = floatPrinterPurchase / 100.0 * floatRepairRate / calcLifetime()
  floatRepairs = floatRepairsHr * floatPrintingTime
  # Return repairs cost
  floatRepairs

# ---
# calcOther - returns other costs for object
# ---

calcOther = ->
  floatOther = undefined
  # Calculations based on spreadsheet
  floatOther = floatOtherCosts
  # Return other cost
  floatOther

# ---
# calcTotalNotFailures - returns cost besides floatFailures for object
# ---

calcTotalNotFailures = ->
  floatTotalNotFailures = undefined
  # Calculate total costs before failures
  floatTotalNotFailures = calcEnergy() + calcFilament()
  floatTotalNotFailures += calcDepreciation() + calcRepairs() + calcOther() if boolInvestmentMode == true
  # Return total costs before failures
  floatTotalNotFailures

# ---
# calcFailures - returns failure costs for object
# ---

calcFailures = ->
  floatFailures = undefined
  # Calculations based on spreadsheet
  floatFailures = calcTotalNotFailures() / 100.0 * floatFailureRate
  # Return floatOther cost
  floatFailures

# ---
# grabInputs - saves input values as globals and cookies
# ---

grabInputs = ->
  # Copy all inputs to global variables
  floatObjectWeight = Number(document.getElementById('object_weight').value)
  floatPrintingTime = Number(document.getElementById('printing_time').value)
  floatElectricRate = Number(document.getElementById('electric_rate').value)
  floatPrinterPower = Number(document.getElementById('printer_power').value)
  floatFilamentCost = Number(document.getElementById('filament_cost').value)
  floatPrinterPurchase = Number(document.getElementById('printer_purchase').value)
  floatPrinterLife = Number(document.getElementById('printer_life').value)
  floatPrinterUse = Number(document.getElementById('printer_daily_use').value)
  floatRepairRate = Number(document.getElementById('repair_rate').value)
  floatOtherCosts = Number(document.getElementById('other_costs').value)
  floatFailureRate = Number(document.getElementById('failure_rate').value)
  boolInvestmentMode = Boolean(document.getElementById('investment_mode').checked)
  document.querySelectorAll('input[data-disabled]').forEach (input) ->
    input.disabled = !boolInvestmentMode
  return

# ---
# inputsValid - validate all inputs
# ---

inputsValid = ->
  boolIsInvalid = undefined
  # Check whether ALL inputs are valid numbers
  boolIsInvalid = isNaN(floatObjectWeight) or isNaN(floatPrintingTime) or isNaN(floatElectricRate) or isNaN(floatPrinterPower) or isNaN(floatFilamentCost) or isNaN(floatPrinterPurchase) or isNaN(floatPrinterLife) or isNaN(floatPrinterUse) or isNaN(floatRepairRate) or isNaN(floatOtherCosts) or isNaN(floatFailureRate)
  # Return true only if all inputs are valid
  !boolIsInvalid

# ---
# calcTotal - returns total costs based on variables, not inputs
# ---

calcTotal = ->
  floatTotal = 0.0
  # If inputs are valid, calc total, else alert user  
  if inputsValid()
    floatTotal = calcTotalNotFailures() 
    floatTotal += calcFailures() if boolInvestmentMode == true

  else
    alert 'Some input fields contain non-numeric values (ie, letters or symbols). Please correct them, then re-calculate!'
  # Return the total
  floatTotal

# ---
# displayTotal - displays total costs for object
# ---

displayTotal = ->
  floatTotal = undefined
  # Copy inputs to global variables
  grabInputs()

  # Save all inputs as cookies
  saveCookies()

  # Calculate total
  floatTotal = calcTotal()

  # Only display new total if inputs were valid
  if inputsValid()
    document.getElementById('total_cost').innerHTML = floatTotal.toFixed(2)
  return

# ---
# resetDefaults - reset all input values to defaults
# ---

resetDefaults = ->
  # Set all input variables to default values
  floatObjectWeight = '100'
  floatPrintingTime = '5'
  floatElectricRate = '0.0568'
  floatPrinterPower = '50'
  floatFilamentCost = '34.19'
  floatPrinterPurchase = '1576'
  floatPrinterLife = '3'
  floatPrinterUse = '2'
  floatRepairRate = '10'
  floatOtherCosts = '0.1'
  floatFailureRate = '10'
  boolInvestmentMode = false
  return

# ---
# displayValues - outputs all global values to the screen
# ---

displayValues = ->
  # Output all global values to the screen
  document.getElementById('object_weight').value = floatObjectWeight
  document.getElementById('printing_time').value = floatPrintingTime
  document.getElementById('electric_rate').value = floatElectricRate
  document.getElementById('printer_power').value = floatPrinterPower
  document.getElementById('filament_cost').value = floatFilamentCost
  document.getElementById('printer_purchase').value = floatPrinterPurchase
  document.getElementById('printer_life').value = floatPrinterLife
  document.getElementById('printer_daily_use').value = floatPrinterUse
  document.getElementById('repair_rate').value = floatRepairRate
  document.getElementById('other_costs').value = floatOtherCosts
  document.getElementById('failure_rate').value = floatFailureRate
  document.getElementById('investment_mode').checked = boolInvestmentMode if boolInvestmentMode == true
  return

# ---
# saveCookies - saves all input variables as cookies
# ---

saveCookies = ->
  setCookie 'floatObjectWeight', floatObjectWeight, COOKIE_DAYS
  setCookie 'floatPrintingTime', floatPrintingTime, COOKIE_DAYS
  setCookie 'floatElectricRate', floatElectricRate, COOKIE_DAYS
  setCookie 'floatPrinterPower', floatPrinterPower, COOKIE_DAYS
  setCookie 'floatFilamentCost', floatFilamentCost, COOKIE_DAYS
  setCookie 'floatPrinterPurchase', floatPrinterPurchase, COOKIE_DAYS
  setCookie 'floatPrinterLife', floatPrinterLife, COOKIE_DAYS
  setCookie 'floatPrinterUse', floatPrinterUse, COOKIE_DAYS
  setCookie 'floatRepairRate', floatRepairRate, COOKIE_DAYS
  setCookie 'floatOtherCosts', floatOtherCosts, COOKIE_DAYS
  setCookie 'floatFailureRate', floatFailureRate, COOKIE_DAYS
  setCookie 'boolInvestmentMode', boolInvestmentMode, COOKIE_DAYS
  return

# ---
# loadCookies - loads all input variables from cookies
# ---

loadCookies = ->
  floatObjectWeight = getCookie('floatObjectWeight')
  floatPrintingTime = getCookie('floatPrintingTime')
  floatElectricRate = getCookie('floatElectricRate')
  floatPrinterPower = getCookie('floatPrinterPower')
  floatFilamentCost = getCookie('floatFilamentCost')
  floatPrinterPurchase = getCookie('floatPrinterPurchase')
  floatPrinterLife = getCookie('floatPrinterLife')
  floatPrinterUse = getCookie('floatPrinterUse')
  floatRepairRate = getCookie('floatRepairRate')
  floatOtherCosts = getCookie('floatOtherCosts')
  floatFailureRate = getCookie('floatFailureRate')
  boolInvestmentMode = getCookie('boolInvestmentMode') == 'true'
  return

# ---
# deleteCookies - deletes all cookies for testing
# ---

deleteCookies = ->
  setCookie 'floatObjectWeight', ''
  setCookie 'floatPrintingTime', ''
  setCookie 'floatElectricRate', ''
  setCookie 'floatPrinterPower', ''
  setCookie 'floatFilamentCost', ''
  setCookie 'floatPrinterPurchase', ''
  setCookie 'floatPrinterLife', ''
  setCookie 'floatPrinterUse', ''
  setCookie 'floatRepairRate', ''
  setCookie 'floatOtherCosts', ''
  setCookie 'floatFailureRate', ''
  setCookie 'boolInvestmentMode', ''
  return

# ---
# DOMContentLoaded - called after the page loads
# ---

document.addEventListener 'DOMContentLoaded', ->
  # If we have cookies saved then load them all
  if getCookie('floatObjectWeight') != ''
    loadCookies()
  else
    resetDefaults()

  # Display values to user
  displayValues()
  displayTotal()

  # Listen to form changes
  document.querySelectorAll('input').forEach (input) ->
    input.addEventListener 'keyup', displayTotal
    return

  document.querySelector('input[type=checkbox]').addEventListener 'click', displayTotal
  return
