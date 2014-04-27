# coding: utf-8
# Copyright(c) Nozomu KURASAWA 2014

require 'nokogiri'
require 'open-uri'
require "cgi"
require "josm_presets_ja_naming_sample/version"

class JosmPresetsJaNamingSample
  WWW_PAGE = "http://wiki.openstreetmap.org/wiki/JA:Naming_sample"

  # === Output Presets xml to STDOUT
  def puts_presets
    doc = Nokogiri::HTML(open(WWW_PAGE))
    puts preset(doc)
  end

  # === Presets (whole)
  # ==== params
  # _doc_:: wikipage (Nokogiri::Node)
  # ==== return
  # String:: presets
  def preset(doc)
    str = ""
str << <<EOS
<presets xmlns="http://josm.openstreetmap.de/tagging-preset-1.0"
         version="#{Time.now.strftime("%Y-%m-%d")}"
         author="Japanese OSM Users"
         ja.author="OSM 日本語ユーザー"
         shortdescription="Chain stores in Japan"
         ja.shortdescription="日本におけるチェーン店"
         link="#{WWW_PAGE}"
         description="Chain stores in Japan"
         ja.description="日本におけるチェーン店">
  <group name="日本におけるチェーン店">
EOS
    tables = doc.css(".wikitable")
    tables.each do |t|
      desc = t.previous_element
      title = desc.previous_element

      str << preset_group(t, title, desc)

    end
str << <<EOS
  </group>
</presets>
EOS
    return str
  end

  # === Presets in a wikitable
  # ==== params
  # _record_:: rows of wikitable (Nokogiri::Node)
  # _title_::  title of wikitable (for tag) (Nokogiri::Node)
  # _desc_::   description of wikitable (Nokogiri::Node)
  # ==== return
  # String:: group entry
  def preset_group(group,title,desc)
    group_str = ""
    group_str << <<EOS
<group name="#{strip_value(desc)}">
EOS
    records = group.css("tr")
    records.each do |r|
      group_str << preset_item(r,title,desc)
    end
    group_str << <<EOS
</group>
EOS
  end

  # === Presets for a item
  # expect follow colomns
  #
  # {| class=wikitable
  # | name
  # | name:en
  # | name:ja
  # | name:ja_rm
  # | branch(example)
  # | brand
  # | operator(example)
  # | memo
  # |----
  # ...
  # |}
  # ==== params
  # _record_:: rows of wikitable (Nokogiri::Node)
  # _title_::  title of wikitable (for tag) (Nokogiri::Node)
  # _desc_::   description of wikitable (Nokogiri::Node)
  # ==== return
  # String:: item entry
  def preset_item(record,title,desc)
    k,v = parse_key_value(title)
    cols = record.css("td")
    return "" if cols[0].nil?
    return <<EOS
<item name="#{strip_value(cols[0])}">
  <label text="#{strip_value(cols[0])}" />
  <label text="(#{strip_value(desc)})" />
  <key key="#{k}" value="#{v}" />
  <key key="name" value="#{strip_value(cols[0])}" />
  <key key="name:en" value="#{strip_value(cols[1])}" />
  <key key="name:ja" value="#{strip_value(cols[2])}" />
  <key key="name:ja_rm" value="#{strip_value(cols[3])}" />
  <key key="brand" value="#{strip_value(cols[5])}" />
  <optional>
    <text key="branch" text="支店名 #{strip_value(cols[4]).nil? ? '' : "(例: #{strip_value(cols[4])})"}" />
    <combo key="operator" values="#{strip_value(cols[6])}"
           text="運営主体 (企業名など)" editable="true"/>
    <combo key="smoking" values="dedicated,yes,separated,isolated,no"
           display_values="喫煙専用,喫煙可,分煙,隔離,喫煙不可"
           text="喫煙可否" editable="false"/>
    <combo key="toilets" values="yes,no"
           display_values="あり,なし" text="トイレ" />
    <combo key="wheelchair" values="yes,limited,no,designated"
           text="車椅子利用" />
  </optional>
  <label text="#{strip_value(cols[7])}" />
</item>
EOS
  end


  # === string for node
  # ==== params
  # _node_:: Nokogiri::Node
  # ==== return
  # String:: xml encoded string
  def strip_value(node)
    return  "" if node.nil?
    return node.content.strip.encode(xml: :text)
  end

  # === parse "key=value" in a node
  # ==== params
  # _node_:: Nokogiri::Node
  # ==== return
  # String, String:: xml encoded string for KEY and VALUE
  def parse_key_value(node)
    strip_value(node) =~ /(\w+=\w+)/
    $1 =~ /(\w+)=(\w+)/
    return $1, $2
  end

end
