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

              @expenses.each do |e|
                pdf.text "Fornededor: #{e.provider.name}",
                  :size => 12, :align => :justify, :inline_format => true, :style => :bold
                pdf.move_down 8

                pdf.text "Valor: #{formatted_currency(e.amount)}",
                  :size => 12, :align => :justify, :inline_format => true, :style => :bold
                pdf.move_down 8

                pdf.text "Data de Vencimento: #{e.duedate.strftime("%d/%m/%y")}",
                  :size => 12, :align => :justify, :inline_format => true, :style => :bold
                pdf.move_down 8

                pdf.text "Categoria: #{e.category.name}",
                  :size => 12, :align => :justify, :inline_format => true, :style => :bold
                pdf.move_down 8

                pdf.text "---------------------------------------------------------------------------------------------------------------"
                total += e.amount
              end
              pdf.text "Total Despesas: #{formatted_currency(total)}", :size => 15, :align => :center, :inline_format => true, :style => :bold
              pdf.move_down 10

              pdf.start_new_page
              pdf.text "Relação de Despesas em Aberto", :size => 15, :style => :bold, :align => :center
              pdf.move_down 12

              @expenses_em_aberto = Expense.where('user_id = ?', current_user.id).where(paymentdate: "")
              total_aberto = 0
              @expenses_em_aberto.each do |aberto|
                pdf.text "Fornededor: #{aberto.provider.name}",
                  :size => 12, :align => :justify, :inline_format => true, :style => :bold
                pdf.move_down 8

                pdf.text "Valor: #{formatted_currency(aberto.amount)}",
                  :size => 12, :align => :justify, :inline_format => true, :style => :bold
                pdf.move_down 8

                pdf.text "Data de Vencimento: #{aberto.duedate.strftime("%d/%m/%y")}",
                  :size => 12, :align => :justify, :inline_format => true, :style => :bold
                pdf.move_down 8

                pdf.text "Categoria: #{aberto.category.name}",
                  :size => 12, :align => :justify, :inline_format => true, :style => :bold
                pdf.move_down 8
        
                pdf.text "---------------------------------------------------------------------------------------------------------------"
                total_aberto += aberto.amount
              end
              pdf.text "Total Despesas em aberto: #{formatted_currency(total_aberto)}", :size => 15, :align => :center, :inline_format => true, :style => :bold
              pdf.move_down 10

              #---------------------
              total_alimentacao = 0
              total_telefone = 0
              total_moradia = 0
              total_lazer = 0
              total_saude = 0
              total_cartoes = 0
              total_internet = 0
              total_educacao = 0
              total_tv = 0
              @expenses.each do |porc|
                if porc.category.name == "Alimentação"
                  total_alimentacao += porc.amount
                end
                if porc.category.name == "Telefone"
                  total_telefone += porc.amount
                end
                if porc.category.name == "Moradia"
                  total_moradia += porc.amount
                end
                if porc.category.name == "Lazer"
                  total_lazer += porc.amount
                end
                if porc.category.name == "Saúde"
                  total_saude += porc.amount
                end
                if porc.category.name == "Cartões"
                  total_cartoes += porc.amount
                end
                if porc.category.name == "Internet"
                  total_internet += porc.amount
                end
                if porc.category.name == "Educação"
                  total_educacao += porc.amount
                end
                if porc.category.name == "TV Assinatura"
                  total_tv += porc.amount
                end
              end
              total_alimentacao_porc = (total_alimentacao * 100) / total
              total_telefone_porc = (total_telefone * 100) / total
              total_moradia_porc = (total_moradia * 100) / total
              total_lazer_porc = (total_lazer * 100) / total
              total_saude_porc = (total_saude * 100) / total
              total_cartoes_porc = (total_cartoes * 100) / total
              total_internet_porc = (total_internet * 100) / total
              total_educacao_porc = (total_educacao * 100) / total
              total_tv_porc = (total_tv * 100) / total
              @datasets = [
                [:Alimentação, [total_alimentacao_porc]],
                [:Telefone, [total_telefone_porc]],
                [:Moradia, [total_moradia_porc]],
                [:Lazer, [total_lazer_porc]],
                [:Saúde, [total_saude_porc]],
                [:Cartões, [total_cartoes_porc]],
                [:Internet, [total_internet_porc]],
                [:Educação, [total_educacao_porc]],
                [:TV, [total_tv_porc]],
                ]
              pdf.start_new_page
              g = Gruff::Pie.new 900
              g.theme = Gruff::Themes::PASTEL
              g.title = "Demonstrativo de Despesas"
              @datasets.each do |data|
                g.data(data[0], data[1])
              end

              # Default theme
              g.write("public/graph.png")

              pdf.image "public/graph.png", :scale => 0.50
              pdf.move_down 10

              pdf.text "Despesas Detalhadas:", :size => 15, :style => :bold, :align => :justify
              pdf.move_down 12

              pdf.text "Alimentação: #{total_alimentacao_porc.round} %"

              pdf.render_file("public/#{ramdom_file_name}.pdf")
            end

            File.open("public/#{ramdom_file_name}.pdf", 'r') do |f|
              send_data f.read.force_encoding('BINARY'), :filename => 'pdf', :type => "application/pdf", :disposition => "inline"
            end
            File.delete("public/#{ramdom_file_name}.pdf")
            File.delete("public/graph.png")

          end
        end
        register_instance_option :link_icon do
            'fa fa-file-pdf-o'
        end
      end 
    end
  end
end        
 
             
