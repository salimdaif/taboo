module UsersHelper
  def tab_hidden(tab, params)
    if tab == 'questionnaire' && !params.present?
      ""
    elsif tab != params
      "hidden"
    end
  end


  def tab_active(tab, params)
    if tab == params
      "active"
    elsif tab == 'questionnaire' && !params.present?
        "active"
    end

  end
end
