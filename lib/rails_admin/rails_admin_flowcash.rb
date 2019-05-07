module RailsAdminFlowCash
end
include ApplicationHelper 
require 'rails_admin/config/actions'
require 'prawn'
require 'gruff'



module RailsAdmin
  module Config
    module Actions
      class FlowCash < Base 
        RailsAdmin::Config::Actions.register(self) 

        register_instance_option :root do 
          true 
        end 

        register_instance_option :visible? do
          true
        end

        register_instance_option :pjax? do 
          false 
        end 

        register_instance_option :controller do
          Proc.new do # Configurando PDF 
            PDF_OPTIONS = { :page_size => "A4",
              :page_layout => :portrait,
              :margin      => [40, 75]
            }
            ramdom_file_name = (0...8).map { (65 + rand(26)).chr }.join

            Prawn::Document.new(PDF_OPTIONS) do |pdf|

              @expenses = Expense.where('user_id = ?', current_user.id)  
              @receipts = Receipt.where('user_id = ?', current_user.id)

              pdf.fill_color "666666"
              pdf.text "Fluxo de Caixa", :size => 32, :style => :bold, :align => :center
              pdf.move_down 80

              total_expenses = 0
              @expenses.each do |expense|
                total_expenses += expense.amount
              end

              pdf.text "Total de Despesas: #{formatted_currency(total_expenses)}"
              pdf.move_down 10

              total_receipts = 0
              @receipts.each do |receipt| 
                total_receipts += receipt.amount
              end

              pdf.text "Total de Receitas: #{formatted_currency(total_receipts)}"
              pdf.move_down 10

              saldo = total_receipts - total_expenses

              if saldo < 0.00
                pdf.text "Seu saldo de #{formatted_currency(saldo)} está negativo! Você precisa analisar onde estão seus maiores gastos !", :color => "ff0000"
              else
                pdf.text "Seu saldo de #{formatted_currency(saldo)} está azul! Você possui #{formatted_currency(saldo)} positivo em seu caixa.", :color => "0000ff"
              end
              pdf.move_down 10

              header = ["Provider", "Amount"]
              table_data = []
              table_data << header
              @expenses.map do |expense|
                table_data << [expense.provider.name, formatted_currency(expense.amount)]
              end
              pdf.table(table_data)
              #data = [["Provider", "Amount"]]  
              #pdf.table(data, :header => true, :position => :center, :column_widths => [200, 100], :row_colors => ["F0F0F0", "FFFFCC"]) 
             

              @expenses_by_month = Expense.where('user_id = ?', current_user.id).where(:created_at => 1.month.ago.beginning_of_month..1.month.ago.end_of_month )
              @receipts_by_month = Receipt.where('user_id = ?', current_user.id).where(:created_at => 1.month.ago.beginning_of_month..1.month.ago.end_of_month )

              @expenses_current_month = Expense.where('user_id = ?', current_user.id).where(:created_at => Date.current.beginning_of_month..Date.current.end_of_month )
              @receipts_current_month = Receipt.where('user_id = ?', current_user.id).where(:created_at => Date.current.beginning_of_month..Date.current.end_of_month )

              total_expense_by_month = 0 
              @expenses_by_month.each do |e|
                total_expense_by_month += e.amount
              end

              total_receipt_by_month = 0 
              @receipts_by_month.each do |e|
                total_receipt_by_month += e.amount
              end

              total_expenses_current_month = 0
              @expenses_current_month.each do |e|
                total_expenses_current_month += e.amount
              end

              total_receipts_current_month = 0
              @receipts_current_month.each do |e|
                total_receipts_current_month += e.amount
              end


               @datasets = [
                           ["Receitas", [total_receipts_current_month, total_receipt_by_month]],
                           ["Despesas", [total_expenses_current_month, total_expense_by_month]],
                           ]

              pdf.start_new_page
              g = Gruff::Bar.new(900)
              g.title = 'Demonstrativo de Gastos X Despesas'
              g.labels = {
                0 => 'Mês Atual',
                1 => 'Mês Anterior'
              }
              @datasets.each do |data|
                g.data(data[0], data[1])
              end
              g.write("public/#{ramdom_file_name}.png")

              pdf.image "public/#{ramdom_file_name}.png", :scale => 0.50
              pdf.move_down 10

              pdf.render_file("public/#{ramdom_file_name}.pdf")
            end

            File.open("public/#{ramdom_file_name}.pdf", 'r') do |f|
              send_data f.read.force_encoding('BINARY'), :filename => 'pdf', :type => "application/pdf", :disposition => "inline"
            end
            File.delete("public/#{ramdom_file_name}.pdf")
            File.delete("public/#{ramdom_file_name}.png")
          end
        end
        register_instance_option :link_icon do
          'fa fa-file-pdf-o'
        end
      end
    end
  end
end
