CREATE OR REPLACE TABLE `KimiaFarma_Datas.Tab_Analysis` AS
SELECT 
    tr.transaction_id,
    tr.date,
    tr.branch_id,
    cb.branch_name,
    cb.kota,
    cb.provinsi,
    cb.rating AS rating_cabang,
    tr.customer_name,
    tr.product_id,
    pr.product_name,
    tr.price,
    tr.discount_percentage,
    
    -- Persentase Gross Profit berdasarkan harga produk
    CASE 
      WHEN tr.price <= 50000 THEN 0.10
      WHEN tr.price <= 100000 THEN 0.15
      WHEN tr.price <= 300000 THEN 0.20
      WHEN tr.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS Gross_Percent,
    
    -- Penjualan bersih setelah diskon
    (tr.price * (1 - (tr.discount_percentage / 100))) AS net_sales,
    
    -- Keuntungan bersih (net_sales * Gross_Percent)
    (tr.price * (1 - (tr.discount_percentage / 100))) * 
    CASE 
      WHEN tr.price <= 50000 THEN 0.10
      WHEN tr.price <= 100000 THEN 0.15
      WHEN tr.price <= 300000 THEN 0.20
      WHEN tr.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS net_profit

FROM `KimiaFarma_Datas.kf_final_transaction` tr
JOIN `KimiaFarma_Datas.kf_kantor_cabang` cb 
  ON tr.branch_id = cb.branch_id
JOIN `KimiaFarma_Datas.kf_product` pr 
  ON tr.product_id = pr.product_id;
