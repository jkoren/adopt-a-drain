# frozen_string_literal: true

require 'dry/schema'
require 'hash_dot'

module CityHelper
  # View helper for reading strings from the config
  def c(key_chain)
    keys = key_chain.to_s.split('.')
    raise 'Must specify keys' if keys.empty?

    config = CityHelper.config(current_city)
    raw(keys.inject(config) { |h, key| h.fetch(key.to_sym) })
  end

  def c?(key_chain)
    keys = key_chain.to_s.split('.')
    raise 'Must specify keys' if keys.empty?

    h = CityHelper.config(current_city)
    keys.each do |k|
      h = h[k.to_sym]
      return false if h.nil?
    end
    true
  end

  def current_config
    CityHelper.config(current_city)
  end

  def set_current_city(city)
    @current_city = CityHelper.check(city)
  end

  def current_city
    @current_city ||= CityHelper.city_for_domain(request.host) if respond_to?(:request)
    @current_city
  end

  def self.city_for_domain(domain)
    @@domains[domain]
  end

  def self.config(name)
    @@cities.fetch(name)
  end

  def self.check(name)
    @@cities.fetch(name)
    name
  end

  def self.cities
    @@cities
  end

  def self.city_names
    @@cities.keys
  end

  def self.load!(city_config_dir, brand_config_dir)
    @@brands = {}
    Dir[File.join(brand_config_dir, '*.yml')].each do |config|
      brand_name = File.basename(config, '.yml')
      brand = BrandSchema.load(config)
      @@brands[brand_name] = brand
    end

    base = File.join(city_config_dir, 'base.yml')
    @@cities = {}
    @@domains = {}
    Dir[File.join(city_config_dir, '*.yml')].each do |config|
      next if config == base

      city_name = File.basename(config, '.yml')
      city = Schema.load(base, config)

      city.brand = @@brands.fetch(city.site.brand)

      @@cities[city_name] = city.to_dot
      city.site.domains.each do |domain|
        @@domains[domain] = city_name
      end
    end
  end

  # Placeholder markup
  def self.p(name)
    "'<b style=\"color: red;\">[#{name}]</b>'"
  end
end

class Schema
  def self.load_yml(config)
    file_contents = IO.read(config)
    file_contents = ERB.new(file_contents).result
    YAML.safe_load(file_contents)
  end

  def self.load(base, config)
    yml = load_yml(base).deep_merge(load_yml(config))
    result = @@schema.call(yml)
    errors = result.errors(full: true).to_h
    raise "Error validating #{config}:\n#{errors}" unless errors.empty?

    result.to_h.to_dot
  end

  @@schema = Dry::Schema.Params do
    required(:city).hash do
      required(:name).filled(:string)
      required(:type).filled(:string)
      required(:title).filled(:string)
      required(:state).filled(:string)
      required(:center).hash do
        required(:lat).filled(:string)
        required(:lng).filled(:string)
      end
      required(:runoff_destination).filled(:string)
      required(:trash_page_url).filled(:string)
      required(:trash_page_label).filled(:string)
      required(:report_issues).filled(:string)
      required(:logo).filled(:string)
      required(:url).filled(:string)
      required(:facebook).filled(:string)
      optional(:instagram).filled(:string)
      required(:twitter).filled(:string)
      optional(:linkedin).filled(:string)
      required(:tos_partial_name).filled(:string)
      required(:contact_email).filled(:string)
    end

    required(:site).hash do
      required(:brand).filled(:string)
      required(:domains).filled(array[:string])
      required(:main_url).filled(:string)
      required(:logo).filled(:string)
      required(:video).maybe(:string)
    end

    required(:org).hash do
      required(:email).filled(:string)
      required(:name).filled(:string)
      required(:logo).filled(:string)
      required(:url).filled(:string)
      required(:phone).filled(:string)
    end

    required(:data).hash do
      required(:file).filled(:string)
      required(:columns).hash do
        optional(:id).filled(:string)
        required(:lat).filled(:string)
        required(:lng).filled(:string)
        optional(:name).filled(array[:string])
      end
    end
  end
end

class BrandSchema
  def self.load_yml(config)
    file_contents = IO.read(config)
    file_contents = ERB.new(file_contents).result
    YAML.safe_load(file_contents)
  end

  def self.load(config)
    yml = load_yml(config)
    result = @@schema.call(yml)
    errors = result.errors(full: true).to_h
    raise "Error validating #{config}:\n#{errors}" unless errors.empty?

    result.to_h.to_dot
  end

  @@schema = Dry::Schema.Params do
    required(:name).filled(:string)
    required(:brand_name).filled(:string)
    required(:button_adopt).filled(:string)
    required(:default_tagline).filled(:string)
    required(:notices_adopted).filled(:string)
    required(:titles_adopt).filled(:string)
    required(:titles_adopted).filled(:string)
    required(:sign_in).filled(:string)
    required(:thank_you).filled(:string)
    required(:gis_icon_adopted).filled(:string)
    required(:gis_icon_in_need).filled(:string)
    required(:imperative).filled(:string)
    required(:adopted).filled(:string)
    required(:adopting).filled(:string)
    required(:details_partial_name).filled(:string)
    required(:change_partial_name).filled(:string)
  end
end

CityHelper.load! File.expand_path('../../config/cities', __dir__), File.expand_path('../../config/brands', __dir__)
