module ApplicationHelper
    def session_link
        if logged_in?
            link_to "Logout", logout_path, method: :delete, :class => "p-2 text-dark"
        else
            link_to "Login", login_path, :class => "p-2 text-dark"
        end
    end
end
