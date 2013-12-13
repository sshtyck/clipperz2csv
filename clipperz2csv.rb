#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'csv'
require 'pp'

JSON_FILE = 'c.json'
CSV_FILE = 'passwords.csv'

json = File.read(JSON_FILE)
ary = JSON.parse(json)

def get_values(c_hash)
  # Get the array of hashes where all particular values are stored.

  cv_hash = c_hash['currentVersion']
  f_hash = cv_hash['fields']

  v_ary = f_hash.values
end

def get_by_key(c_hash, key)
  # Get the array of particular keys from the array of hashes.
  
  k_ary = [] 
  v_ary = get_values(c_hash)

  v_ary.each do |value|
    k_ary << value[key]   
  end
   
  k_ary.map { |str| str == '"' ? '' : str }
end

def get_titles(c_hash)
  # Get fields titles to populate the table.
  
  t_ary = []
  t_ary << 'label'
  t_ary << get_by_key(c_hash, 'label')
  t_ary << 'notes'

  t_ary.flatten!
end

def parse_a_card(c_hash)
  # Return values of all fields.

  csv_row = []
  csv_row << c_hash['label'].strip
  csv_row << get_by_key(c_hash, 'value')
  csv_row << c_hash['data']['notes'].strip

  csv_row.flatten!
end

def _debug
  # Printf debugging.

  c_hash = ary[100] 
  pp get_values(c_hash)
  pp get_titles(c_hash)

end

def get_my_passwords(ary)
  # Get the array of all the rows.

  r_ary = []
  ary.each do |hash|
    r_ary << parse_a_card(hash)
  end

  r_ary
end

def to_csv(ary)
  # Finally.

  r_ary = get_my_passwords(ary)

  CSV.open(CSV_FILE, "w") do |csv|
    csv << get_titles(ary[0])
    r_ary.each do |row|
      csv << row
    end
  end

end

to_csv(ary)
