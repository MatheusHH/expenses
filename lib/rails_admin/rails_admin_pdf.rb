module RailsAdminFlowCash
end
include ApplicationHelper 
require 'rails_admin/config/actions'
require 'prawn'
require 'gruff'
 
module RailsAdmin
  module Config
    module Actions
      class Pdf < Base 
        RailsAdmin::Config::Actions.register(self) 

        register_instance_option :collection do 
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
              total = 0  

              pdf.fill_color "666666"
              pdf.text "Relatório do Financeiro", :size => 32, :style => :bold, :align => :center
              pdf.move_down 80

              pdf.text "Usuário: #{current_user.name}", :size => 12, :style => :bold, :align => :center
              pdf.move_down 20

              pdf.text "Relação Total de Despesas", :size => 15, :style => :bold, :align => :center
              pdf.move_down 12

              @expenses.each do |expense|
                total += expense.amount
              end

              header = ["Fornecedor", "Data de Vencimento", "Valor"]
              table_data = []
              table_data << header
              @expenses.map do |expense|
                table_data << [expense.provider.name, expense.duedate.strftime("%d/%m/%y"), formatted_currency(expense.amount)]
              end
              #pdf.table(table_data, :position => :center, :column_widths => [200, 100, 100], :row_colors => ["F0F0F0", "FFFFCC"])
              pdf.table(table_data) do |t|
                t.row(0).background_color = 'ffffff'
                t.position = :center
                t.column_widths = [200, 100, 100]
                t.row_colors = ["F0F0F0", "FFFFCC"]
              end
              pdf.move_down 10
              #data = [["Provider", "Amount"]]  
              #pdf.table(data, :header => true, :position => :center, :column_widths => [200, 100], :row_colors => ["F0F0F0", "FFFFCC"]) 

              pdf.text "Total Despesas: #{formatted_currency(total)}", :size => 15, :align => :center, :inline_format => true, :style => :bold
              pdf.move_down 10

              pdf.start_new_page
              pdf.text "Relação de Despesas em Aberto", :size => 15, :style => :bold, :align => :center
              pdf.move_down 12

              @expenses_em_aberto = Expense.where('user_id = ?', current_user.id).where(paymentdate: "")
              total_aberto = 0

              @expenses_em_aberto.each do |aberto|
                total_aberto += aberto.amount
              end

              header_aberto = ["Fornecedor", "Data de Vencimento", "Valor"]
              table_data_aberto = []
              table_data_aberto << header_aberto
              @expenses_em_aberto.map do |expense|
                table_data_aberto << [expense.provider.name, expense.duedate.strftime("%d/%m/%y"), formatted_currency(expense.amount)]
              end
              pdf.table(table_data_aberto) do |t|
                t.row(0).background_color = 'ffffff'
                t.position = :center
                t.column_widths = [200, 100, 100]
                t.row_colors = ["F0F0F0", "FFFFCC"]
              end
              #pdf.table(table_data_aberto, :position => :center, :column_widths => [200, 100], :row_colors => ["F0F0F0", "FFFFCC"])
              pdf.move_down 10

              pdf.text "Total Despesas em aberto: #{formatted_currency(total_aberto)}", :size => 15, :align => :center, :inline_format => true, :style => :bold
              pdf.move_down 10

              #---------------------

              @category = Category.where('user_id = ?', current_user.id)

              datasets1 = {}
              total_by_category = 0
              @category.each do |c|
                total_by_category = 0
                name = c.name
                @expenses.each do |e|
                  if e.category.name == name
                    total_by_category += e.amount
                  end
                end 
                if total > 0
                  total_by_category_porc = (total_by_category * 100) / total
                else
                  total_by_category_porc = 0
                end

                datasets1["#{c.name}"] = total_by_category_porc     
              end

              pdf.start_new_page
              g = Gruff::Pie.new 900
              g.theme = Gruff::Themes::PASTEL
              g.add_color('#FF00EF')
              g.add_color('#0033FF')
              g.title = "Demonstrativo de Despesas"
              datasets1.each do |data|
                g.data(data[0], data[1])
              end
              ##########################################################

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
 
             
