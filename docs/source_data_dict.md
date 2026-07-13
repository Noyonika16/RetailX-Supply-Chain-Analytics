| Table       | Description         | Primary Key              | Important Columns      |
| ----------- | ------------------- | ------------------------ | ---------------------- |
| customers   | Customer master     | customer_id              | city, state            |
| orders      | Order lifecycle     | order_id                 | status, purchase date  |
| order_items | Transaction details | order_id + order_item_id | product, seller, price |
| products    | Product catalog     | product_id               | category, weight       |
| sellers     | Seller master       | seller_id                | city, state            |
