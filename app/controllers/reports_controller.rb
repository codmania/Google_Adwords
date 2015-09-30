# See this document for reference:
#   https://developers.google.com/adwords/api/docs/appendix/reports
require "csv"

class ReportsController < ApplicationController

  before_filter :get_date_range, only: [:garage_flooring, :garage_cabinetry, :all_campaigns, :in_home]

  def index
    @selected_account = selected_account
    @reports = Report.reports
    @formats = ReportFormat.report_formats
  end

  def get
    @selected_account = selected_account
    return if @selected_account.nil?

    # validate_data(params)
    api = get_adwords_api
    report_utils = api.report_utils
    
    begin
      campaign_name = '05 - Carter - Norther Virginia - Garage'
      group1_name = '09 - Floor Coating'
      group2_name = '10 - Garage Flooring'
      during = '20150801, 20150831'
      report_query = "SELECT Criteria, AdGroupName, " +
      "Impressions, Clicks, Cost, AveragePosition FROM KEYWORDS_PERFORMANCE_REPORT " +
      "WHERE CampaignName = '#{campaign_name}' AND AdGroupName NOT_IN ['#{group1_name}', '#{group2_name}'] " +
      "DURING #{during} "
      # "ORDER BY Clicks "
      # "LIMIT 0, 1 "

      binding.pry
      report_csv = report_utils.download_report_with_awql(report_query, 'CSV')
      report_hash = csv_to_hash(report_csv)

      binding.pry
      
    rescue AdwordsApi::Errors::ReportError => e
      @error = e.message
    end
  end

  def real_time_stats
    binding.pry
    report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
      '05 - Carter - Norther Virginia - In Home', 'TODAY')
    binding.pry
    @report_data = report_array.last
    @report_data[:cost] = @report_data[:cost].to_f / 1000000
  end

  def garage_flooring
    @keywords_yesterday = {
      :keyword => 'hello',
      :impressions => '300',
      :clicks => '100',
      :cost => '$200'
    }

    rpt_array = get_adgroup_report('05 - Carter - Norther Virginia - Garage', '09 - Floor Coating', 
      '10 - Garage Flooring', @filter_value, true)
    @report = rpt_array.last
    @keywords = get_top_keywords(rpt_array)
  end

  def garage_cabinetry
    # rpt_array = get_adgroup_report('05 - Carter - Norther Virginia - Garage', '09 - Floor Coating', 
    #   '10 - Garage Flooring', 'YESTERDAY', false)
    # @report_yesterday = rpt_array.last
    # @keywords_yesterday = get_top_keywords(rpt_array)

    # rpt_array = get_adgroup_report('05 - Carter - Norther Virginia - Garage', '09 - Floor Coating', 
    #   '10 - Garage Flooring', 'LAST_7_DAYS', false)
    # @report_last = rpt_array.last
    # @keywords_last = get_top_keywords(rpt_array)

    # rpt_array = get_adgroup_report('05 - Carter - Norther Virginia - Garage', '09 - Floor Coating', 
    #   '10 - Garage Flooring', 'THIS_MONTH', false)
    # @report_month = rpt_array.last
    # @keywords_month = get_top_keywords(rpt_array)

    # rpt_array = get_adgroup_report('05 - Carter - Norther Virginia - Garage', '09 - Floor Coating', 
    #   '10 - Garage Flooring', '20150801, 20150831', false)
    # @report_august = rpt_array.last
    # @keywords_august = get_top_keywords(rpt_array)

    # rpt_array = get_adgroup_report('05 - Carter - Norther Virginia - Garage', '09 - Floor Coating', 
    #   '10 - Garage Flooring', '20150701, 20150731', false)
    # @report_july = rpt_array.last
    # @keywords_july = get_top_keywords(rpt_array)
  end

  def in_home
    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - Garage', 'YESTERDAY')
    # @report_yesterday = report_array.last
    # @keywords_yesterday = get_top_keywords(report_array)

    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - Garage', 'LAST_7_DAYS')
    # @report_last = report_array.last
    # @keywords_last = get_top_keywords(report_array)

    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - Garage', 'THIS_MONTH')
    # @report_month = report_array.last
    # @keywords_month = get_top_keywords(report_array)

    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - Garage', '20150801, 20150831')
    # @report_august = report_array.last
    # @keywords_august = get_top_keywords(report_array)    

    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - Garage', '20150701, 20150731')
    # @report_july = report_array.last
    # @keywords_july = get_top_keywords(report_array)
  end

  def all_campaigns
    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - In Home', 'YESTERDAY')
    # @report_yesterday = report_array.last
    # @keywords_yesterday = get_top_keywords(report_array)

    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - In Home', 'LAST_7_DAYS')
    # @report_last = report_array.last
    # @keywords_last = get_top_keywords(report_array)

    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - In Home', 'THIS_MONTH')
    # @report_month = report_array.last
    # @keywords_month = get_top_keywords(report_array)

    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - In Home', '20150801, 20150831')
    # @report_august = report_array.last
    # @keywords_august = get_top_keywords(report_array)    

    # report_array = get_campaign_report('05 - Carter - Norther Virginia - Garage', 
    #   '05 - Carter - Norther Virginia - In Home', '20150701, 20150731')
    # @report_july = report_array.last
    # @keywords_july = get_top_keywords(report_array)    
  end

  def contact_us
  end

  private

  def validate_data(data)
    format = ReportFormat.report_format_for_type(data[:format])
    raise StandardError, 'Unknown format' if format.nil?
    report = Report.report_for_type(data[:type])
    raise StandardError, 'Unknown report type' if report.nil?
  end

  def get_campaign_report(campaign_name1, campaign_name2, during)
    campaign_query = "SELECT Criteria, " +
      "Impressions, Clicks, Cost, AveragePosition FROM KEYWORDS_PERFORMANCE_REPORT " +
      "WHERE CampaignName IN ['#{campaign_name1}', '#{campaign_name2}'] " +
      "DURING #{during}"
    binding.pry
    campaign_report = get_report_with_csv(campaign_query)

    return campaign_report
  end

  def get_adgroup_report(campaign_name, group_name1, group_name2, during, exclude)

    if exclude == true
      adgroup_query = "SELECT Criteria, " +
        "Impressions, Ctr, Clicks, Cost, AveragePosition FROM KEYWORDS_PERFORMANCE_REPORT " +
        "WHERE CampaignName = '#{campaign_name}' AND AdGroupName IN ['#{group_name1}', '#{group_name2}'] " +
        "DURING #{during} "
    else
      adgroup_query = "SELECT Criteria, " +
        "Impressions, Ctr, Clicks, Cost, AveragePosition FROM KEYWORDS_PERFORMANCE_REPORT " +
        "WHERE CampaignName = '#{campaign_name}' AND AdGroupName NOT_IN ['#{group_name1}', '#{group_name2}'] " +
        "DURING #{during} "
    end

    adgroup_report = get_report_with_csv(adgroup_query)

    return adgroup_report
  end  

  def get_report_with_csv(report_query)
    @selected_account = selected_account
    return if @selected_account.nil?

    # validate_data(params)
    api = get_adwords_api
    report_utils = api.report_utils
    
    begin
      rpt_query = report_query      
      report_csv = report_utils.download_report_with_awql(rpt_query, 'CSV')      
      report_hash = csv_to_hash(report_csv)

      return report_hash
      
    rescue AdwordsApi::Errors::ReportError => e
      @error = e.message
    end
  end

  def csv_to_hash(csv_data)
    csv = csv_data
    csv = csv.split("\n")[1..-1].join("\n")
    tmp = CSV.new(csv, :headers => true, :header_converters => :symbol)
    hash = tmp.to_a.map { |row| row.to_hash }
    binding.pry
    return hash
  end

  def get_top_keywords(group_data)
    hashes = group_data
    group = hashes.sort_by { |hsh| hsh[:clicks] }.reverse

    top_group = Array.new
    group[1..10].each do |grp|
      top_group << grp
    end
    binding.pry
    return top_group

  end

  def get_date_range
    @filter = params[:filter] || 'yesterday'
    case @filter
    when 'yesterday'
      @filter_value = 'YESTERDAY'
    when 'last_month'
      @filter_value = "#{(Date.today - 1.months).beginning_of_month.strftime(%B %Y)} "
    end
    @from
    @to
    @filter_label = 

    ['yesterday', 'this']
  end

end