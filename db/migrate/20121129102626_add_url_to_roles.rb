# -*- coding: utf-8 -*-

# Map technical department name to human name
DEPT = {
  "centrum" => "Centrum",
  "fastighetskontoret" => "Fastighetskontoret",
  "fosie" => "Fosie",
  "fritidsforvaltningen" => "Fritidsförvaltningen",
  "gatukontoret" => "Gatukontoret",
  "husie" => "Husie",
  "hyllie" => "Hyllie",
  "kirseberg" => "Kirseberg",
  "kulturforvaltningen" => "Kulturförvaltningen",
  "limhamn-bunkeflo" => "Limhamn-Bunkeflo",
  "miljoforvaltningen" => "Miljöförvaltningen",
  "oxie" => "Oxie",
  "rosengard" => "Rosengård",
  "serviceforvaltningen" => "Serviceförvaltningen",
  "sociala-resursforvaltningen" => "Sociala resursförvaltningen",
  "stadsbyggnadskontoret" => "Stadsbyggnadskontoret",
  "stadskontoret" => "Stadskontoret",
  "stadsrevisionen" => "Stadsrevisionen",
  "sodra-innerstaden" => "Södra innerstaden",
  "utbildningsforvaltningen" => "Utbildningsförvaltningen",
  "vastra-innerstaden" => "Västra innerstaden",
  "overformyndarforvaltningen" => "Överförmyndarförvaltningen",
  "ekonomi" => "Ekonomi",
  "folkhalsa" => "Folkhälsa",
  "forskola-utbildning" => "Förskola & utbildning",
  "individ-familj" => "Individ & familj",
  "integration-arbetsmarknad" => "Integration & arbetsmarknad",
  "it" => "IT",
  "hr" => "HR",
  "kommunikationsarbete" => "Kommunikationsarbete",
  "naringsliv-foretagare" => "Näringsliv/företagare",
  "trygghets-sakerhetsarbete" => "Trygghets- & säkerhetsarbete",
  "turism" => "Turism",
  "vard-omsorg" => "Vård & omsorg",
  "arendeberedning" => "Ärendeberedning"
}

class AddUrlToRoles < ActiveRecord::Migration
  def up
    add_column :roles, :homepage_url, :string

    # Set initial values of homepage_url field based on DEPT and human name in name column
    Role.reset_column_information
    Role.all.each do |r|
      r.homepage_url = "http://komin.malmo.se/#{ DEPT.invert[r.name] }"
      r.save(validate: false)
    end
  end

  def down
    remove_column :roles, :homepage_url
  end
end
