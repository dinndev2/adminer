module TenantsHelper  
  def supercharged?(tenant)
    return if tenant.nil?
    tenant.supercharged?
  end
end