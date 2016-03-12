require 'Scraper'

# Basketball Scraper Class
class BasketballScraper < Scraper
  def self.mapping_file_path
    File.join(ROOT, 'config', 'mappings', 'basketball_scraper_mapping.yml')
  end

  def season_headers
    @bot.search("//table[@id='totals']/thead/tr/th").map do |header|
      header.children[0].text
    end
  end

  def parse_season_stats
    parsed_data = {}
    headers = season_headers
    @bot.search("//table[@id='totals']/tbody/tr").each do |tr|
      year = tr.attributes['id'].value.match(/totals\.(\w+)/)[1]
      parsed_data[year.to_i] = parse_row(tr.children, headers)
    end
    parsed_data
  end

  def parse_row(data, head)
    rows = data.reject { |el| el.class == Nokogiri::XML::Text }
    rows_parsed = rows.map do |row|
      if row.children[0].children[0]
        row.children[0].children[0].text
      else
        row.children[0].text
      end
    end
    data = head.zip(rows_parsed)
    Hash[data]
  end
end
