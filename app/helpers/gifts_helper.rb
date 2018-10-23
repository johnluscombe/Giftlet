module GiftsHelper
  def editing(gift)
    @user == current_user and params[:render_edit].to_i == gift.id
  end

  def purchased_by(gift)
    if gift.purchaser_id == current_user.id
      link = purchased_by_you(gift)
      content_tag(:div, link, class: 'text-xs-right')
    elsif gift.purchaser_id
      text = purchased_by_other(gift)
      content_tag(:div, text, class: 'text-success text-nowrap text-xs-right')
    else
      text = purchased_by_nil(gift)
      content_tag(:div, text, class: 'text-success text-xs-right')
    end
  end

  def mark_as_purchased(gift)
    link = link_to(gift_mark_as_purchased_path(gift),
            method: :patch, class: 'btn btn-sm btn-secondary') do

      content_tag(:i, nil, class: 'fa fa-check')
    end

    content_tag(:div, link)
  end

  def gift_name(gift)
    if gift.url.blank?
      content = gift.name
    else
      content = link_to gift.name, gift.full_url, target: '_blank'
    end

    content_tag(:div, content)
  end

  def gift_price(gift)
    if !gift.price.blank? and gift.price != 0.0
      content_tag(:div, number_to_currency(gift.price))
    end
  end

  def gift_edit(gift)
    link_to user_gifts_path(@user, render_edit: gift.id) do
      content_tag(:i, nil, class: 'fa fa-cog', 'aria-hidden': 'true')
    end
  end

  def gift_delete(gift)
    confirm_text = 'Are you sure you want to delete this gift?'

    link_to gift_path(gift), method: :delete, data: { confirm: confirm_text } do
      content_tag(:i, nil, class: 'fa fa-trash', 'aria-hidden': 'true')
    end
  end

  def name_field(form)
    form.text_field(:name,
                    class: 'form-control form-control-sm',
                    placeholder: 'Name',
                    required: true)
  end

  def url_field(form)
    form.text_field(:url,
                    class: 'form-control form-control-sm',
                    placeholder: 'URL (optional)')
  end

  def description_field(form)
    form.text_area(:description,
                   class: 'form-control form-control-sm',
                   placeholder: 'Description (optional)')
  end

  def price_field(form)
    form.text_field(:price_as_dollars,
                    class: 'form-control form-control-sm edit-gift-price',
                    placeholder: 'Price')
  end

  def submit_button(form)
    form.submit 'SAVE', class: 'btn btn-success btn-sm'
  end

  def cancel_button
    link_to 'CANCEL', user_gifts_path(@user), class: 'btn btn-outline-danger btn-sm'
  end

  private

  def purchased_by_you(gift)
    link_to gift_mark_as_unpurchased_path(gift),
            method: :patch, class: 'btn btn-sm btn-success' do

      content_tag(:i, nil, class: 'fa fa-check')
    end
  end

  def purchased_by_other(gift)
    text = "#{ gift.purchaser.first_name } #{ gift.purchaser.last_name }"
    content_tag(:i, nil, class: 'fa fa-check') + text
  end

  def purchased_by_nil(gift)
    content_tag(:i, 'Purchased', class: 'fa fa-check')
  end
end
