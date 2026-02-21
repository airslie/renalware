# frozen_string_literal: true

class Forms::Generic::Homecare::Signoff < Forms::Base
  def build
    move_down 40
    font_size 10
    consultant
    move_down 40
    prescriber
    move_down 40
    text "Order number:", style: :bold
    move_down 10
    text "Other pharmacy comments:", style: :bold
  end

  private

  def consultant
    table(
      [
        [heading("Consultant:"), args.consultant]
      ],
      column_widths: { 0 => 80, 1 => 210 },
      **table_styles,
      **underlined_table_style
    )
  end

  def prescriber
    table(
      [
        [heading("Prescriber:"), heading("Signature:"), heading("Date:")]
      ],
      column_widths: {
        0 => 220,
        1 => 215,
        2 => 100
      },
      **table_styles.merge(underlined_table_style)
    )
  end
end
