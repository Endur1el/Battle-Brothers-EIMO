this.getroottable().Const.EIMO.hookCharacterScreen <- function()
{
	::mods_hookNewObjectOnce("ui/screens/character/character_screen", function(o) {
	  
		o.onFavoriteInventoryItem <- function(itemID)
		{
			if (!("Assets" in this.World)) return;
			local item = this.World.Assets.getStash().getItemByInstanceID(itemID).item;
			
			if (item.m.isFavorite)
			{
				item.m.isFavorite = false;
			}
			else
			{
				item.m.isFavorite = true;
			}
			return true;
		}
		
		o.onRepairAllButtonClicked <- function()
		{
			if (!("Assets" in this.World)) return;
			local items = this.World.Assets.getStash().getItems();
				foreach( item in items )
				{
					if (item != null && item.getItemType() < this.Const.Items.ItemType.Ammo)
					{
						local dratio = this.Const.EIMO.getDratio(item);
						if (dratio > this.Const.EIMO.repairThreshold)
						{
							item.setToBeRepaired(true);
						}
					}
				}
				this.loadStashList();
		}

		o.onSetForSaleInventoryItem <- function(data)
		{
			if (!("Assets" in this.World)) return;
			local item = this.World.Assets.getStash().getItemByInstanceID(data).item;
			if (item != null)
			{
				if (!this.World.Flags.has(getItemSaleFlag(item)) || this.World.Flags.get(getItemSaleFlag(item)) == 0)
				{
					this.World.Flags.set(getItemSaleFlag(item), 1);
					this.loadStashList();
					return true;
				}
				else if (item != null && this.World.Flags.get(getItemSaleFlag(item)) == 1)
				{
					this.World.Flags.set(getItemSaleFlag(item), 0);
					this.loadStashList();
					return true;
				}
			}
			else
			{
				return false;
			}
		}

		o.EIMOonChangeVisibilityButtonClicked <- function ()
		{
			switch (visibilityLevel) 
			{
			    case 0: case 1:
			        visibilityLevel = visibilityLevel + 1;
			        break;
			   	case 2: default:
			   		visibilityLevel = 0;
			}
			this.loadStashList();
			return visibilityLevel;
		}


		o.EIMOgetVisibilityLevel <- function ()
		{
		  	return visibilityLevel;
		}
	});
}