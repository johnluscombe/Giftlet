module UsersHelper
  def first_name_field(form)
    form.text_field(:first_name,
                    class: 'form-control',
                    placeholder: 'First Name',
                    required: true)
  end

  def last_name_field(form)
    form.text_field(:last_name,
                    class: 'form-control',
                    placeholder: 'Last Name',
                    required: true)
  end

  def username_field(form)
    form.text_field(:username,
                    class: 'form-control',
                    placeholder: 'Username',
                    required: true)
  end

  def user_password_field(form)
    form.password_field(:password,
                        class: 'form-control',
                        placeholder: 'Password',
                        required: true)
  end

  def password_confirmation_field(form)
    form.password_field(:password_confirmation,
                        class: 'form-control',
                        placeholder: 'Password Confirmation',
                        required: true)
  end

  def user_submit_button(form, text)
    form.submit text, class: 'btn btn-success'
  end

  def user_cancel_button
    link_to 'CANCEL', login_path, class: 'btn btn-outline-danger'
  end

  def edit_basic_info_modal_options
    {
        tabindex: '-1',
        role: 'dialog',
        'aria-labelledby': 'editBasicInfoLabel',
        'aria-hidden': 'true'
    }
  end

  def edit_basic_info_form_options
    {
        id: 'edit-basic-info-form',
        url: { controller: 'users', action: 'update_basic_information' },
        html: {id: nil},
        method: :patch
    }
  end

  def close_modal_button_options
    {
        type: 'button',
        'data-dismiss': 'modal',
        'aria-label': 'Close'
    }
  end

  def edit_password_modal_options
    {
        tabindex: '-1',
        role: 'dialog',
        'aria-labelledby': 'changePasswordLabel',
        'aria-hidden': 'true'
    }
  end

  def edit_password_form_options
    {
        id: 'edit-password-form',
        url: { controller: 'users', action: 'update_password' },
        html: {id: nil},
        method: :patch
    }
  end

  def old_password_field
    password_field_tag(:old_password,
                       nil,
                       class: 'form-control change-password-field',
                       placeholder: 'Old Password',
                       required: true)
  end

  def edit_password_field(form)
    form.password_field(:password,
                        id: 'password',
                        class: 'form-control change-password-field',
                        placeholder: 'New Password',
                        required: true,
                        oninput: 'checkConfirmation();')
  end

  def edit_password_conf_field(form)
    form.password_field(:password_confirmation,
                        id: 'password_confirmation',
                        class: 'form-control change-password-field',
                        placeholder: 'New Password Confirmation',
                        required: true,
                        oninput: 'checkConfirmation();')
  end

  def update_password_button(form)
    form.submit('UPDATE',
                id: 'update_password_button',
                class: 'btn btn-success',
                disabled: true)
  end
end
