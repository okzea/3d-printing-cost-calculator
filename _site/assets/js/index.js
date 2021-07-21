
/*
 * Forked from https://makersylvaindenis.000webhostapp.com/cost_calc.js by makersylvaindenis
 */

(function() {
  var COOKIE_DAYS, boolInvestmentMode, calcDepreciation, calcEnergy, calcFailures, calcFilament, calcLifetime, calcOther, calcRepairs, calcTotal, calcTotalNotFailures, deleteCookies, displayTotal, displayValues, floatElectricRate, floatFailureRate, floatFilamentCost, floatObjectWeight, floatOtherCosts, floatPrinterLife, floatPrinterPower, floatPrinterPurchase, floatPrinterUse, floatPrintingTime, floatRepairRate, getCookie, grabInputs, inputsValid, loadCookies, resetDefaults, saveCookies, setCookie;

  COOKIE_DAYS = 365;

  floatObjectWeight = '';

  floatPrintingTime = '';

  floatElectricRate = '';

  floatPrinterPower = '';

  floatFilamentCost = '';

  floatPrinterPurchase = '';

  floatPrinterLife = '';

  floatPrinterUse = '';

  floatRepairRate = '';

  floatOtherCosts = '';

  floatFailureRate = '';

  boolInvestmentMode = '';

  setCookie = function(strCookieName, intCookieValue, intExpireDays) {
    var dateExDate;
    dateExDate = void 0;
    dateExDate = new Date;
    dateExDate.setDate(dateExDate.getDate() + intExpireDays);
    document.cookie = strCookieName + '=' + escape(intCookieValue) + (intExpireDays === null ? '' : ';expires=' + dateExDate.toGMTString());
  };

  getCookie = function(strCookieName) {
    var intCookieEnd, intCookieStart, strCookieValue;
    intCookieStart = void 0;
    intCookieEnd = void 0;
    strCookieValue = void 0;
    strCookieValue = '';
    if (document.cookie.length > 0) {
      intCookieStart = document.cookie.indexOf(strCookieName + '=');
      if (intCookieStart !== -1) {
        intCookieStart = intCookieStart + strCookieName.length + 1;
        intCookieEnd = document.cookie.indexOf(';', intCookieStart);
        if (intCookieEnd === -1) {
          intCookieEnd = document.cookie.length;
        }
        strCookieValue = unescape(document.cookie.substring(intCookieStart, intCookieEnd));
      }
    }
    return strCookieValue;
  };

  calcEnergy = function() {
    var floatEnergy, floatKW, floatPoundsHour;
    floatEnergy = void 0;
    floatKW = void 0;
    floatPoundsHour = void 0;
    floatKW = floatPrinterPower / 1000.0;
    floatPoundsHour = floatKW * floatElectricRate;
    floatEnergy = floatPoundsHour * floatPrintingTime;
    return floatEnergy;
  };

  calcFilament = function() {
    var floatFilament;
    floatFilament = void 0;
    floatFilament = floatFilamentCost / 1000.0 * floatObjectWeight;
    return floatFilament;
  };

  calcLifetime = function() {
    var floatLifetime;
    floatLifetime = void 0;
    floatLifetime = 365.0 * floatPrinterLife * floatPrinterUse;
    return floatLifetime;
  };

  calcDepreciation = function() {
    var floatDeprHr, floatDepreciation, floatLifetime;
    floatDepreciation = void 0;
    floatLifetime = void 0;
    floatDeprHr = void 0;
    floatLifetime = calcLifetime();
    floatDeprHr = floatPrinterPurchase / floatLifetime;
    floatDepreciation = floatDeprHr * floatPrintingTime;
    return floatDepreciation;
  };

  calcRepairs = function() {
    var floatRepairs, floatRepairsHr;
    floatRepairs = void 0;
    floatRepairsHr = void 0;
    floatRepairsHr = floatPrinterPurchase / 100.0 * floatRepairRate / calcLifetime();
    floatRepairs = floatRepairsHr * floatPrintingTime;
    return floatRepairs;
  };

  calcOther = function() {
    var floatOther;
    floatOther = void 0;
    floatOther = floatOtherCosts;
    return floatOther;
  };

  calcTotalNotFailures = function() {
    var floatTotalNotFailures;
    floatTotalNotFailures = void 0;
    floatTotalNotFailures = calcEnergy() + calcFilament();
    if (boolInvestmentMode === true) {
      floatTotalNotFailures += calcDepreciation() + calcRepairs() + calcOther();
    }
    return floatTotalNotFailures;
  };

  calcFailures = function() {
    var floatFailures;
    floatFailures = void 0;
    floatFailures = calcTotalNotFailures() / 100.0 * floatFailureRate;
    return floatFailures;
  };

  grabInputs = function() {
    floatObjectWeight = Number(document.getElementById('object_weight').value);
    floatPrintingTime = Number(document.getElementById('printing_time').value);
    floatElectricRate = Number(document.getElementById('electric_rate').value);
    floatPrinterPower = Number(document.getElementById('printer_power').value);
    floatFilamentCost = Number(document.getElementById('filament_cost').value);
    floatPrinterPurchase = Number(document.getElementById('printer_purchase').value);
    floatPrinterLife = Number(document.getElementById('printer_life').value);
    floatPrinterUse = Number(document.getElementById('printer_daily_use').value);
    floatRepairRate = Number(document.getElementById('repair_rate').value);
    floatOtherCosts = Number(document.getElementById('other_costs').value);
    floatFailureRate = Number(document.getElementById('failure_rate').value);
    boolInvestmentMode = Boolean(document.getElementById('investment_mode').checked);
    document.querySelectorAll('input[data-disabled]').forEach(function(input) {
      return input.disabled = !boolInvestmentMode;
    });
  };

  inputsValid = function() {
    var boolIsInvalid;
    boolIsInvalid = void 0;
    boolIsInvalid = isNaN(floatObjectWeight) || isNaN(floatPrintingTime) || isNaN(floatElectricRate) || isNaN(floatPrinterPower) || isNaN(floatFilamentCost) || isNaN(floatPrinterPurchase) || isNaN(floatPrinterLife) || isNaN(floatPrinterUse) || isNaN(floatRepairRate) || isNaN(floatOtherCosts) || isNaN(floatFailureRate);
    return !boolIsInvalid;
  };

  calcTotal = function() {
    var floatTotal;
    floatTotal = 0.0;
    if (inputsValid()) {
      floatTotal = calcTotalNotFailures();
      if (boolInvestmentMode === true) {
        floatTotal += calcFailures();
      }
    } else {
      alert('Some input fields contain non-numeric values (ie, letters or symbols). Please correct them, then re-calculate!');
    }
    return floatTotal;
  };

  displayTotal = function() {
    var floatTotal;
    floatTotal = void 0;
    grabInputs();
    saveCookies();
    floatTotal = calcTotal();
    if (inputsValid()) {
      document.getElementById('total_cost').innerHTML = floatTotal.toFixed(2);
    }
  };

  resetDefaults = function() {
    floatObjectWeight = '100';
    floatPrintingTime = '5';
    floatElectricRate = '0.0568';
    floatPrinterPower = '50';
    floatFilamentCost = '34.19';
    floatPrinterPurchase = '1576';
    floatPrinterLife = '3';
    floatPrinterUse = '2';
    floatRepairRate = '10';
    floatOtherCosts = '0.1';
    floatFailureRate = '10';
    boolInvestmentMode = false;
  };

  displayValues = function() {
    document.getElementById('object_weight').value = floatObjectWeight;
    document.getElementById('printing_time').value = floatPrintingTime;
    document.getElementById('electric_rate').value = floatElectricRate;
    document.getElementById('printer_power').value = floatPrinterPower;
    document.getElementById('filament_cost').value = floatFilamentCost;
    document.getElementById('printer_purchase').value = floatPrinterPurchase;
    document.getElementById('printer_life').value = floatPrinterLife;
    document.getElementById('printer_daily_use').value = floatPrinterUse;
    document.getElementById('repair_rate').value = floatRepairRate;
    document.getElementById('other_costs').value = floatOtherCosts;
    document.getElementById('failure_rate').value = floatFailureRate;
    if (boolInvestmentMode === true) {
      document.getElementById('investment_mode').checked = boolInvestmentMode;
    }
  };

  saveCookies = function() {
    setCookie('floatObjectWeight', floatObjectWeight, COOKIE_DAYS);
    setCookie('floatPrintingTime', floatPrintingTime, COOKIE_DAYS);
    setCookie('floatElectricRate', floatElectricRate, COOKIE_DAYS);
    setCookie('floatPrinterPower', floatPrinterPower, COOKIE_DAYS);
    setCookie('floatFilamentCost', floatFilamentCost, COOKIE_DAYS);
    setCookie('floatPrinterPurchase', floatPrinterPurchase, COOKIE_DAYS);
    setCookie('floatPrinterLife', floatPrinterLife, COOKIE_DAYS);
    setCookie('floatPrinterUse', floatPrinterUse, COOKIE_DAYS);
    setCookie('floatRepairRate', floatRepairRate, COOKIE_DAYS);
    setCookie('floatOtherCosts', floatOtherCosts, COOKIE_DAYS);
    setCookie('floatFailureRate', floatFailureRate, COOKIE_DAYS);
    setCookie('boolInvestmentMode', boolInvestmentMode, COOKIE_DAYS);
  };

  loadCookies = function() {
    floatObjectWeight = getCookie('floatObjectWeight');
    floatPrintingTime = getCookie('floatPrintingTime');
    floatElectricRate = getCookie('floatElectricRate');
    floatPrinterPower = getCookie('floatPrinterPower');
    floatFilamentCost = getCookie('floatFilamentCost');
    floatPrinterPurchase = getCookie('floatPrinterPurchase');
    floatPrinterLife = getCookie('floatPrinterLife');
    floatPrinterUse = getCookie('floatPrinterUse');
    floatRepairRate = getCookie('floatRepairRate');
    floatOtherCosts = getCookie('floatOtherCosts');
    floatFailureRate = getCookie('floatFailureRate');
    boolInvestmentMode = getCookie('boolInvestmentMode') === 'true';
  };

  deleteCookies = function() {
    setCookie('floatObjectWeight', '');
    setCookie('floatPrintingTime', '');
    setCookie('floatElectricRate', '');
    setCookie('floatPrinterPower', '');
    setCookie('floatFilamentCost', '');
    setCookie('floatPrinterPurchase', '');
    setCookie('floatPrinterLife', '');
    setCookie('floatPrinterUse', '');
    setCookie('floatRepairRate', '');
    setCookie('floatOtherCosts', '');
    setCookie('floatFailureRate', '');
    setCookie('boolInvestmentMode', '');
  };

  document.addEventListener('DOMContentLoaded', function() {
    if (getCookie('floatObjectWeight') !== '') {
      loadCookies();
    } else {
      resetDefaults();
    }
    displayValues();
    displayTotal();
    document.querySelectorAll('input').forEach(function(input) {
      input.addEventListener('keyup', displayTotal);
    });
    document.querySelector('input[type=checkbox]').addEventListener('click', displayTotal);
  });

}).call(this);
