# coding: utf-8
require 'bible_gateway/version'
require 'nokogiri'
require 'typhoeus'

class BibleGatewayError < StandardError; end

class BibleGateway
  GATEWAY_URL = "http://www.biblegateway.com"

  VERSIONS = {
    :new_international_version => "NIV",
    :new_american_standard_bible => "NASB",
    :the_message => "MSG",
    :amplified_bible => "AMP",
    :new_living_translation => "NLT",
    :king_james_version => "KJV",
    :english_standard_version => "ESV",
    :contemporary_english_version => "CEV",
    :new_king_james_version => "NKJV",
    :new_century_version => "NCV",
    :king_james_version_21st_century => "KJ21",
    :american_standard_version => "ASV",
    :youngs_literal_translation => "YLT",
    :darby_translation => "DARBY",
    :holman_christian_standard_bible => "HCSB",
    :new_international_readers_version => "NIRV",
    :wycliffe_new_testament => "WYC",
    :worldwide_english_new_testament => "WE",
    :new_international_version_uk => "NIVUK",
    :todays_new_international_version => "TNIV",
    :world_english_bible => "WEB",
    "Amuzgo de Guerrero"=>"AMU",
"Arabic Bible: Easy-to-Read Version"=>"ERV-AR",
"Arabic Life Application Bible"=>"ALAB",
"Awadhi Bible: Easy-to-Read Version"=>"ERV-AWA",
"1940 Bulgarian Bible"=>"BG1940",
"Bulgarian Bible"=>"BULG",
"Bulgarian New Testament: Easy-to-Read Version"=>"ERV-BG",
"Bulgarian Protestant Bible"=>"BPB",
"Chinanteco de Comaltepec"=>"CCO",
"Ang Pulong Sa Dios"=>"APSD-CEB",
"Cherokee New Testament"=>"CHR",
"Cakchiquel Occidental"=>"CKW",
"Bible 21"=>"B21",
"Slovo na cestu"=>"SNC",
"Bibelen på hverdagsdansk"=>"BPH",
"Dette er Biblen på dansk"=>"DN1933",
"Hoffnung für Alle"=>"HOF",
"Luther Bibel 1545"=>"LUTH1545",
"Neue Genfer Übersetzung"=>"NGU-DE",
"Schlachter 1951"=>"SCH1951",
"Schlachter 2000"=>"SCH2000",
"21st Century King James Version"=>"KJ21",
"American Standard Version"=>"ASV",
"Amplified Bible"=>"AMP",
"Common English Bible"=>"CEB",
"Complete Jewish Bible"=>"CJB",
"Contemporary English Version"=>"CEV",
"Darby Translation"=>"DARBY",
"Douay-Rheims 1899 American Edition"=>"DRA",
"Easy-to-Read Version"=>"ERV",
"English Standard Version"=>"ESV",
"English Standard Version Anglicised"=>"ESVUK",
"Expanded Bible"=>"EXB",
"1599 Geneva Bible"=>"GNV",
"GOD’S WORD Translation"=>"GW",
"Good News Translation"=>"GNT",
"Holman Christian Standard Bible"=>"HCSB",
"J.B. Phillips New Testament"=>"PHILLIPS",
"Jubilee Bible 2000"=>"JUB",
"King James Version"=>"KJV",
"Authorized (King James) Version"=>"AKJV",
"Lexham English Bible"=>"LEB",
"Living Bible"=>"TLB",
"The Message"=>"MSG",
"Mounce Reverse-Interlinear New Testament"=>"MOUNCE",
"Names of God Bible"=>"NOG",
"New American Standard Bible"=>"NASB",
"New Century Version"=>"NCV",
"New English Translation (NET Bible)"=>"NET",
"New International Reader's Version"=>"NIRV",
"New International Version"=>"NIV",
"New International Version - UK"=>"NIVUK",
"New King James Version"=>"NKJV",
"New Life Version"=>"NLV",
"New Living Translation"=>"NLT",
"New Revised Standard Version"=>"NRSV",
"New Revised Standard Version, Anglicised"=>"NRSVA",
"New Revised Standard Version, Anglicised Catholic Edition"=>"NRSVACE",
"New Revised Standard Version Catholic Edition"=>"NRSVCE",
"Orthodox Jewish Bible"=>"OJB",
"Revised Standard Version"=>"RSV",
"Revised Standard Version Catholic Edition"=>"RSVCE",
"The Voice"=>"VOICE",
"World English Bible"=>"WEB",
"Worldwide English (New Testament)"=>"WE",
"Wycliffe Bible"=>"WYC",
"Young's Literal Translation"=>"YLT",
"La Biblia de las Américas"=>"LBLA",
"Dios Habla Hoy"=>"DHH",
"Jubilee Bible 2000 (Spanish)"=>"JBS",
"Nueva Biblia Latinoamericana de Hoy"=>"NBLH",
"Nueva Traducción Viviente"=>"NTV",
"Nueva Versión Internacional"=>"NVI",
"Nueva Versión Internacional (Castilian)"=>"CST",
"Palabra de Dios para Todos"=>"PDT",
"La Palabra (España)"=>"BLP",
"La Palabra (Hispanoamérica)"=>"BLPH",
"Reina Valera Contemporánea"=>"RVC",
"Reina-Valera 1960"=>"RVR1960",
"Reina Valera 1977"=>"RVR1977",
"Reina-Valera 1995"=>"RVR1995",
"Reina-Valera Antigua"=>"RVA",
"Traducción en lenguaje actual"=>"TLA",
"Raamattu 1933/38"=>"R1933",
"La Bible du Semeur"=>"BDS",
"Louis Segond"=>"LSG",
"Nouvelle Edition de Genève – NEG1979"=>"NEG1979",
"Segond 21"=>"SG21",
"1550 Stephanus New Testament"=>"TR1550",
"1881 Westcott-Hort New Testament"=>"WHNU",
"1894 Scrivener New Testament"=>"TR1894",
"SBL Greek New Testament"=>"SBLGNT",
"Habrit Hakhadasha/Haderekh"=>"HHH",
"The Westminster Leningrad Codex"=>"WLC",
"Hindi Bible: Easy-to-Read Version"=>"ERV-HI",
"Ang Pulong Sang Dios"=>"HLGN",
"Knijga O Kristu"=>"CRO",
"Haitian Creole Version"=>"HCV",
"Hungarian Károli"=>"KAR",
"Hungarian Bible: Easy-to-Read Version"=>"ERV-HU",
"Hungarian New Translation"=>"NT-HU",
"Hawai‘i Pidgin"=>"HWP",
"Icelandic Bible"=>"ICELAND",
"La Bibbia della Gioia"=>"BDG",
"Conferenza Episcopale Italiana"=>"CEI",
"La Nuova Diodati"=>"LND",
"Nuova Riveduta 1994"=>"NR1994",
"Nuova Riveduta 2006"=>"NR2006",
"Jacalteco, Oriental"=>"JAC",
"Kekchi"=>"KEK",
"Biblia Sacra Vulgata"=>"VULGATE",
"Maori Bible"=>"MAORI",
"Macedonian New Testament"=>"MNT",
"Marathi Bible: Easy-to-Read Version"=>"ERV-MR",
"Mam, Central"=>"MVC",
"Mam de Todos Santos Chuchumatán"=>"MVJ",
"Reimer 2001"=>"REIMER",
"Nepali Bible: Easy-to-Read Version"=>"ERV-NE",
"Náhuatl de Guerrero"=>"NGU",
"Het Boek"=>"HTB",
"Det Norsk Bibelselskap 1930"=>"DNB1930",
"En Levende Bok"=>"LB",
"Oriya Bible: Easy-to-Read Version"=>"ERV-OR",
"Punjabi Bible: Easy-to-Read Version"=>"ERV-PA",
"Nowe Przymierze"=>"NP",
"Słowo Życia"=>"SZ-PL",
"Ne Bibliaj Tik Nawat"=>"NBTN",
"João Ferreira de Almeida Atualizada"=>"AA",
"Nova Versão Internacional"=>"NVI-PT",
"O Livro"=>"OL",
"Portuguese New Testament: Easy-to-Read Version"=>"VFL",
"Mushuj Testamento Diospaj Shimi"=>"MTDS",
"Quiché, Centro Occidental"=>"QUT",
"Cornilescu"=>"RMNN",
"Nouă Traducere În Limba Română"=>"NTLR",
"Russian New Testament: Easy-to-Read Version"=>"ERV-RU",
"Russian Synodal Version"=>"RUSV",
"Slovo Zhizny"=>"SZ",
"Nádej pre kazdého"=>"NPK",
"Somali Bible"=>"SOM",
"Albanian Bible"=>"ALB",
"Serbian New Testament: Easy-to-Read Version"=>"ERV-SR",
"Nya Levande Bibeln"=>"SVL",
"Svenska 1917"=>"SV1917",
"Svenska Folkbibeln"=>"SFB",
"Neno: Bibilia Takatifu"=>"SNT",
"Tamil Bible: Easy-to-Read Version"=>"ERV-TA",
"Thai New Contemporary Bible"=>"TNCV",
"Thai New Testament: Easy-to-Read Version"=>"ERV-TH",
"Ang Salita ng Diyos"=>"SND",
"Nkwa Asem"=>"NA-TWI",
"Ukrainian Bible"=>"UKR",
"Ukrainian New Testament: Easy-to-Read Version"=>"ERV-UK",
"Urdu Bible: Easy-to-Read Version"=>"ERV-UR",
"Uspanteco"=>"USP",
"1934 Vietnamese Bible"=>"VIET",
"Bản Dịch 2011"=>"BD2011",
"Vietnamese Bible: Easy-to-Read Version"=>"BPT",
"Chinese Contemporary Bible"=>"CCB",
"Chinese New Testament: Easy-to-Read Version"=>"ERV-ZH",
"Chinese New Version (Traditional)"=>"CNVT",
"Chinese Standard Bible (Simplified)"=>"CSBS",
"Chinese Standard Bible (Traditional)"=>"CSBT",
"Chinese Union Version (Simplified)"=>"CUVS",
"Chinese Union Version (Traditional)"=>"CUV",
"Chinese Union Version Modern Punctuation (Simplified)"=>"CUVMPS",
"Chinese Union Version Modern Punctuation (Traditional)"=>"CUVMPT",
    
  }

  def self.versions
    VERSIONS.keys
  end

  attr_accessor :version

  def initialize(version = :king_james_version)
    self.version = version
  end

  def version=(version)
    raise BibleGatewayError, 'Unsupported version' unless VERSIONS.keys.include? version
    @version = version
  end

  def lookup(passage)
    response = Typhoeus.get(passage_url(passage), followlocation: true)
    doc = Nokogiri::HTML(response.body)
    scrape_passage(doc)
  end

  private
    def passage_url(passage)
      URI.escape "#{GATEWAY_URL}/passage/?search=#{passage}&version=#{VERSIONS[version]}"
    end

    def scrape_passage(doc)
      container = doc.css('div#content')
      title = container.css('h1')[0].content
      segment = doc.at('div.result-text-style-normal')
      segment.search('sup.crossreference').remove # remove cross reference links
      segment.search('sup.footnote').remove # remove footnote links
      segment.search("div.crossrefs").remove # remove cross references
      segment.search("div.footnotes").remove # remove footnotes
      segment.search("span.text").each do |span|
        text = span.inner_html
        span.swap text
      end

      segment.search('sup.versenum').each do |sup|
        text = sup.content
        sup.swap "<sup>#{text}</sup>"
      end
      content = segment.inner_html.gsub('<p></p>', '').gsub(/<!--.*?-->/, '').strip
      {:title => title, :content => content }
    end
end
