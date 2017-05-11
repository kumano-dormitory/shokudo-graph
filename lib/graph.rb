require 'roo-xls'
require 'matrix'
require 'rbplotly'

module Plotly::Offline::Exportable
  def to_html
    create_html(@data, layout: @layout, embedded: true).render
  end
end

def generate_plot(filepath)
	shokudo = Roo::Excel.new(filepath)

	core_rows = []
	shokudo.each_with_pagename do |_, sheet|
		core_rows += sheet.to_matrix.to_a.drop(7).take(50)
	end

	core_rows_filled = core_rows.map.with_index do |row, i|
		[0,1,2].each do |j|
			if row[j].nil?
				row[j] = core_rows[i-1][j]
			else
				row[j] = row[j].to_i if row[j].is_a? Float
			end
		end
		[row[0], row[1], row[2], row[3], row.last]
	end.select { |row| !row[3].nil? }.select { |row| !(row[3].match(/小/) && row[3].match(/計/)) }

	date_to_row = core_rows_filled.group_by { |row| "#{row[0]}月#{row[1]}日（#{row[2]}）" }
	Plotly::Plot.new(data: [
		{ x: date_to_row.keys, y: date_to_row.map { |_, rows| rows.map { |row| row.last }.sum }, type: :bar, name: '原材料費' },
		{ x: date_to_row.keys, y: date_to_row.map { 420 }, name: '単食券' },
		{ x: date_to_row.keys, y: date_to_row.map { 390 }, name: '橙食券' }
	], layout: { height: 600 })
end
