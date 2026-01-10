module InsuranceCompanyMethods
  extend ActiveSupport::Concern

  # List of insurance companies with their types
  INSURANCE_COMPANIES = {
    # Health Insurance Companies
    "Aditya Birla Health Insurance Co Ltd" => "Health",
    "Care Health Insurance Ltd" => "Health",
    "Manipal Cigna Health Insurance Company Limited" => "Health",
    "Niva Bupa Health Insurance Co Ltd" => "Health",
    "Star Health Allied Insurance Co Ltd" => "Health",

    # Life Insurance Companies
    "ICICI Prudential Life Insurance Co Ltd" => "Life",
    "HDFC Life Insurance Co Ltd" => "Life",
    "SBI Life Insurance Co Ltd" => "Life",
    "LIC of India" => "Life",
    "Bajaj Allianz Life Insurance Co Ltd" => "Life",
    "Max Life Insurance Co Ltd" => "Life",
    "Tata AIA Life Insurance Co Ltd" => "Life",
    "Kotak Mahindra Life Insurance Co Ltd" => "Life",
    "Aditya Birla Sun Life Insurance Co Ltd" => "Life",
    "Reliance Nippon Life Insurance Co Ltd" => "Life",
    "PNB MetLife India Insurance Co Ltd" => "Life",
    "Canara HSBC Oriental Bank of Commerce Life Insurance Co Ltd" => "Life",
    "Aviva Life Insurance Co India Ltd" => "Life",
    "Exide Life Insurance Co Ltd" => "Life",

    # Motor/General Insurance Companies
    "Acko General Insurance Limited" => "Motor",
    "Bajaj Allianz General Insurance Company Limited" => "Motor",
    "Cholamandalam MS General Insurance Co Ltd" => "Motor",
    "Go Digit General Insurance" => "Motor",
    "HDFC ERGO General Insurance Co Ltd" => "Motor",
    "IFFCO TOKIO General Insurance Co Ltd" => "Motor",
    "Kotak Mahindra General Insurance Company Limited" => "Motor",
    "Liberty General Insurance Ltd" => "Motor",
    "National Insurance Co Ltd" => "Motor",
    "Navi General Insurance Limited" => "Motor",
    "Oriental Insurance Company Limited" => "Motor",
    "Raheja QBE General Insurance Co Ltd" => "Motor",
    "Reliance General Insurance Co Ltd" => "Motor",
    "Royal Sundaram General Insurance Co Ltd" => "Motor",
    "Shriram General Insurance Company Limited" => "Motor",
    "Tata AIG General Insurance Co Ltd" => "Motor",
    "The New India Assurance Co Ltd" => "Motor",
    "United India Insurance Company Limited" => "Motor",
    "Universal Sompo General Insurance Co Ltd" => "Motor",
    "Zuno General Insurance Ltd" => "Motor",

    # General Insurance Companies
    "Agriculture Insurance Company of India Ltd" => "General",
    "ECGC Limited" => "General",
    "Generalli Central Insurance" => "General",
    "Kshema General Insurance Limited" => "General"
  }.freeze

  private

  # Get all insurance companies
  def insurance_companies_list
    INSURANCE_COMPANIES.keys
  end

  # Get health insurance companies only
  def health_insurance_companies
    INSURANCE_COMPANIES.select { |name, type| type == "Health" }.keys
  end

  # Get life insurance companies only
  def life_insurance_companies
    INSURANCE_COMPANIES.select { |name, type| type == "Life" }.keys
  end

  # Get motor insurance companies only
  def motor_insurance_companies
    INSURANCE_COMPANIES.select { |name, type| type == "Motor" }.keys
  end

  # Get general insurance companies only
  def general_insurance_companies
    INSURANCE_COMPANIES.select { |name, type| type == "General" }.keys
  end

  # Get companies by insurance type
  def companies_by_type(insurance_type)
    case insurance_type.to_s.downcase
    when 'health'
      health_insurance_companies
    when 'life'
      life_insurance_companies
    when 'motor'
      motor_insurance_companies
    when 'general'
      general_insurance_companies
    else
      insurance_companies_list
    end
  end

  # Get options for select dropdown
  def insurance_company_options
    INSURANCE_COMPANIES.map { |name, type| ["#{name} (#{type})", name] }
  end

  # Get health insurance options for select dropdown
  def health_insurance_options
    health_insurance_companies.map { |name| [name, name] }
  end

  # Get life insurance options for select dropdown
  def life_insurance_options
    life_insurance_companies.map { |name| [name, name] }
  end

  # Get motor insurance options for select dropdown
  def motor_insurance_options
    motor_insurance_companies.map { |name| [name, name] }
  end

  # Get general insurance options for select dropdown
  def general_insurance_options
    general_insurance_companies.map { |name| [name, name] }
  end

  # Get company type by name
  def insurance_company_type(name)
    INSURANCE_COMPANIES[name]
  end

  # Check if company is health insurance
  def health_insurance?(name)
    insurance_company_type(name) == "Health"
  end

  # Check if company is life insurance
  def life_insurance?(name)
    insurance_company_type(name) == "Life"
  end

  # Check if company is motor insurance
  def motor_insurance?(name)
    insurance_company_type(name) == "Motor"
  end

  # Check if company is general insurance
  def general_insurance?(name)
    insurance_company_type(name) == "General"
  end
end