if Items.find().count() is 0
    items = [
        {
            name: "Movado Men's 0606570 Circa Stainless Steel Watch with Brown Leather Band",
            user: 0,
            page_title: "Amazon.com: Movado Men's 0606570 Circa Stainless Steel Watch with Brown Leather Band: Watches",
            url: "http://www.amazon.com/gp/product/B007X0SU4I/ref=s9_al_gw_g241_i5?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=desktop-2&pf_rd_r=038V0Q7KYH9HECDKM60H&pf_rd_t=36701&pf_rd_p=2054015862&pf_rd_i=desktop",
            site: "amazon.com",
            classification: ["Clothing", "Shoes & Jewelry", "Men", "Watches", "Wrist Watches"],
            features: [
                "Dress watch in stainless steel featuring rose gold-tone markers, logo under 12 o'clock, and croco-embossed leather band",
                "Swiss quartz movement with analog display",
                "40mm case diameter",
                "Features synthetic sapphire crystal dial window, buckle closure, date window at 3 o'clock, and dauphine hands",
                "Water resistant to 99 feet (30 M): withstands rain and splashes of water, but not showering or submersion"
                ],
            brand: "Movado",
            model: "606570",
            image: "http://ecx.images-amazon.com/images/I/8169jahjDqL._UY606_.jpg",
            price: 795,
            most_recent_open: 1428287000,
            most_recent_close: 1428287258,
            total_time_open: 10000,
            rating: 3.7,
            reviews: "http://www.amazon.com/Movado-0606570-Circa-Stainless-Leather/product-reviews/B007X0SU4I/ref=cm_cr_dp_see_all_summary?ie=UTF8&showViewpoints=1&sortBy=byRankDescending"
        },
        {
            name: "Movado Men's 0606570 Circa Stainless Steel Watch with Brown Leather Band, Version 2",
            user: 0,
            url: "http://www.amazon.com/gp/product/B007X0SU4I/ref=s9_al_gw_g241_i5?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=desktop-2&pf_rd_r=038V0Q7KYH9HECDKM60H&pf_rd_t=36701&pf_rd_p=2054015862&pf_rd_i=desktop",
            classification: ["Clothing", "Shoes & Jewelry", "Men", "Watches", "Wrist Watches"],
            features: [
                "Dress watch in stainless steel featuring rose gold-tone markers, logo under 12 o'clock, and croco-embossed leather band",
                "Swiss quartz movement with analog display",
                "40mm case diameter",
                "Features synthetic sapphire crystal dial window, buckle closure, date window at 3 o'clock, and dauphine hands",
                "Water resistant to 99 feet (30 M): withstands rain and splashes of water, but not showering or submersion"
                ],
            brand: "Movado",
            model: "606570",
            image: "http://ecx.images-amazon.com/images/I/8169jahjDqL._UY606_.jpg",
            price: 795,
        },
        {
            name: "Movado Men's 0606570 Circa Stainless Steel Watch with Brown Leather Band, Version 3",
            user: 0,
            url: "http://www.amazon.com/gp/product/B007X0SU4I/ref=s9_al_gw_g241_i5?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=desktop-2&pf_rd_r=038V0Q7KYH9HECDKM60H&pf_rd_t=36701&pf_rd_p=2054015862&pf_rd_i=desktop",
            classification: ["Clothing", "Shoes & Jewelry", "Men", "Watches", "Wrist Watches"],
            features: [
                "Dress watch in stainless steel featuring rose gold-tone markers, logo under 12 o'clock, and croco-embossed leather band",
                "Swiss quartz movement with analog display",
                "40mm case diameter",
                "Features synthetic sapphire crystal dial window, buckle closure, date window at 3 o'clock, and dauphine hands",
                "Water resistant to 99 feet (30 M): withstands rain and splashes of water, but not showering or submersion"
                ],
            brand: "Movado",
            model: "606570",
            image: "http://ecx.images-amazon.com/images/I/8169jahjDqL._UY606_.jpg",
            price: 795,
        }
    ]

    for item in items
        Items.insert(item)

if Categories.find().count() is 0
    Categories.insert({
        name: "Wrist Watches",
        user: 0,
        items1: ["nw8w7TFyn4aS4fejM", "sJAJLyYC3uaSNAuQm", "h5FZJkefCtgCKhwxp"],
        items2: ["aMphQ29K8f22jPrW8", "GyFXCZEruvY8Tehto", "K6cHT83PAy9qHeF9h"]
    })

if Meteor.users.find().count() is 0
    admin = Assets.getText('admin').split(',')

    Accounts.createUser 
        username: admin[0]
        email: admin[1]
        password: admin[2]
        profile:
          first_name: admin[3]
          last_name: admin[4]