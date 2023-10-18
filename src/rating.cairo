//
// @author x.com/0xRockW3 <cihanbits@gmail.com>
// Created 18.10.23

// Ratings for StarknetHubTR 
// Users can give stars between 1, 2, 3, 4, 5

use starknet::ContractAddress;

#[starknet::interface]
trait Rating<TContractState> {
    fn set_rating(ref self: TContractState, value: u8);
    fn get_ratings(self: @TContractState) -> Array<u8>;
}

#[starknet::contract]
mod rocksratings {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use super::Rating;

    #[storage]
    struct Storage {
        owner: ContractAddress,
        star_1: u8,
        star_2: u8,
        star_3: u8,
        star_4: u8,
        star_5: u8,
        registered_caller: LegacyMap::<ContractAddress, bool>,
    }

    #[external(v0)]
    impl RatingImpl of Rating<ContractState> {
        fn set_rating(ref self: ContractState, value: u8) {
            // let you_rated = self.is_already_rated();
            // assert(you_rated == true, 'ALREADY_RATED');

            assert(
                value == 1_u8 || value == 2 || value == 3_u8 || value == 4_u8 || value == 5_u8,
                'POSSIBLE_ratings_1-5'
            );

            if value == 1 {
                let star_1 = self.star_1.read();
                self.star_1.write(star_1 + 1);
                self.register_caller();
            } else if value == 2 {
                let star_2 = self.star_2.read();
                self.star_2.write(star_2 + 1);
                self.register_caller();
            } else if value == 3 {
                let star_3 = self.star_3.read();
                self.star_3.write(star_3 + 1);
                self.register_caller();
            } else if value == 4 {
                let star_4 = self.star_4.read();
                self.star_4.write(star_4 + 1);
                self.register_caller();
            } else if value == 5 {
                let star_5 = self.star_5.read();
                self.star_5.write(star_5 + 1);
                self.register_caller();
            }
        }

        fn get_ratings(self: @ContractState) -> Array<u8> {
            let mut ratings = ArrayTrait::new();
            ratings.append(self.star_1.read());
            ratings.append(self.star_2.read());
            ratings.append(self.star_3.read());
            ratings.append(self.star_4.read());
            ratings.append(self.star_5.read());
            ratings
        }
    }

    #[generate_trait]
    impl Voting of VotingModules {
        fn register_caller(ref self: ContractState) {
            let caller = get_caller_address();
            self.registered_caller.write(caller, true);
        // Call Event
        }
        fn is_already_rated(ref self: ContractState) -> bool {
            let caller = get_caller_address();
            self.registered_caller.read(caller)
        }
        fn max_stars(ref self: ContractState, value: u8) -> bool {
            if value > 5 {
                // call_event
                true
            } else {
                false
            }
        }
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}
}
