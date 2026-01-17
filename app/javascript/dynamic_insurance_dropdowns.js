// Dynamic Insurance Dropdowns
// Handles broker code type switching and dynamic loading of agency codes and insurance companies

export function initializeDynamicDropdowns() {
  const brokerCodeSelect = document.getElementById('life_insurance_broker_code_type') ||
                          document.getElementById('health_insurance_broker_code_type');
  const agencyCodeSelect = document.getElementById('life_insurance_agency_code_id') ||
                          document.getElementById('health_insurance_agency_code_id');
  const insuranceCompanySelect = document.getElementById('life_insurance_insurance_company_name') ||
                               document.getElementById('health_insurance_insurance_company_name');
  const agencyCodeLabel = document.querySelector('label[for="' + (agencyCodeSelect ? agencyCodeSelect.id : '') + '"]');

  if (!brokerCodeSelect || !agencyCodeSelect || !insuranceCompanySelect) {
    console.log('Dynamic dropdown elements not found');
    return;
  }

  // Determine the base URL based on current page
  const currentPath = window.location.pathname;
  const isLifeInsurance = currentPath.includes('/life');
  const baseUrl = isLifeInsurance ? '/admin/life_insurances' : '/admin/health_insurances';

  // Handle broker code type change
  brokerCodeSelect.addEventListener('change', function() {
    const brokerType = this.value;

    // Reset agency code and insurance company dropdowns
    clearDropdown(agencyCodeSelect);

    // Update agency code label based on broker type
    if (agencyCodeLabel) {
      if (brokerType === 'direct') {
        agencyCodeLabel.textContent = 'Agency Code (All Agents)*';
      } else if (brokerType === 'broking') {
        agencyCodeLabel.textContent = 'Agency Code (All Brokers)*';
      }
    }

    if (brokerType) {
      // Load agency codes based on broker type
      loadAgencyCodes(baseUrl, brokerType, agencyCodeSelect, insuranceCompanySelect);

      // For broking mode, load insurance companies independently
      if (brokerType === 'broking') {
        loadInsuranceCompanies(baseUrl, insuranceCompanySelect);
      }
    }
  });

  // Handle agency code selection for Direct mode
  agencyCodeSelect.addEventListener('change', function() {
    const brokerType = brokerCodeSelect.value;

    if (brokerType === 'direct' && this.value) {
      // In Direct mode, auto-set insurance company based on agency code selection
      const selectedOption = this.options[this.selectedIndex];
      const companyName = selectedOption.dataset.companyName;

      if (companyName) {
        setDropdownValue(insuranceCompanySelect, companyName);
      }
    }
  });

  // Initialize insurance companies dropdown on page load
  loadInsuranceCompanies(baseUrl, insuranceCompanySelect);
}

// Load agency codes based on broker type
function loadAgencyCodes(baseUrl, brokerType, agencyCodeSelect, insuranceCompanySelect) {
  showLoading(agencyCodeSelect);

  fetch(`${baseUrl}/agency_codes_for_broker_type?broker_type=${brokerType}`)
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        populateDropdown(agencyCodeSelect, data.data, 'Search and select...');

        // Store company name data for direct mode
        if (brokerType === 'direct') {
          data.data.forEach(item => {
            const option = agencyCodeSelect.querySelector(`option[value="${item.id}"]`);
            if (option) {
              option.dataset.companyName = item.company_name;
            }
          });

          // Clear insurance company dropdown for manual selection in direct mode
          clearDropdown(insuranceCompanySelect);
        }
      } else {
        showError('Failed to load agency codes: ' + data.message);
      }
    })
    .catch(error => {
      console.error('Error loading agency codes:', error);
      showError('Error loading agency codes');
    })
    .finally(() => {
      hideLoading(agencyCodeSelect);
    });
}

// Load insurance companies
function loadInsuranceCompanies(baseUrl, insuranceCompanySelect) {
  fetch(`${baseUrl}/insurance_companies_for_type`)
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        populateDropdown(insuranceCompanySelect, data.data, 'Search and select company...');
      } else {
        showError('Failed to load insurance companies: ' + data.message);
      }
    })
    .catch(error => {
      console.error('Error loading insurance companies:', error);
      showError('Error loading insurance companies');
    });
}

// Utility functions
function clearDropdown(select) {
  select.innerHTML = '<option value="">Select...</option>';
}

function populateDropdown(select, data, placeholder = 'Select...') {
  select.innerHTML = `<option value="">${placeholder}</option>`;

  data.forEach(item => {
    const option = document.createElement('option');
    option.value = item.id;
    option.textContent = item.text;
    select.appendChild(option);
  });
}

function setDropdownValue(select, value) {
  for (let i = 0; i < select.options.length; i++) {
    if (select.options[i].value === value || select.options[i].textContent === value) {
      select.selectedIndex = i;
      break;
    }
  }
}

function showLoading(select) {
  select.disabled = true;
  select.style.opacity = '0.6';
}

function hideLoading(select) {
  select.disabled = false;
  select.style.opacity = '1';
}

function showError(message) {
  console.error(message);
  // You can add toast notification here if available
}

// Auto-initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
  initializeDynamicDropdowns();
});